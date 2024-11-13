<?php
include('koneksi.php');

if (!$con) {
    echo 'Koneksi gagal';
    return;
}


$query = "SELECT 
            MAX(suhu) AS suhumax, 
            MIN(suhu) AS suhumin, 
            ROUND(AVG(suhu), 2) AS suhurata 
          FROM sensor_168";
$result = mysqli_query($con, $query);

if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);


    $arr = array(
        "suhumax" => $row['suhumax'],
        "suhumin" => $row['suhumin'],
        "suhurata" => $row['suhurata']
    );


    $query_max_humid = "
        SELECT id, suhu, humid, ts 
        FROM sensor_168 
        WHERE suhu = {$arr['suhumax']} OR humid = (SELECT MAX(humid) FROM sensor_168)
        ORDER BY ts ASC";
    $result_max_humid = mysqli_query($con, $query_max_humid);

    $nilai_suhu_max_humid_max = [];
    while ($row = mysqli_fetch_assoc($result_max_humid)) {
        $nilai_suhu_max_humid_max[] = array(
            "id" => $row['id'],
            "suhu" => $row['suhu'],
            "humid" => $row['humid'],
            "timestamp" => $row['ts']
        );
    }

    $arr['nilai_suhu_max_humid_max'] = $nilai_suhu_max_humid_max;


    $query_month_year = "
        SELECT DISTINCT DATE_FORMAT(ts, '%m-%Y') AS month_year
        FROM sensor_168
        ORDER BY month_year ASC";
    $result_month_year = mysqli_query($con, $query_month_year);

    $month_year_max = [];
    while ($row = mysqli_fetch_assoc($result_month_year)) {
        $month_year_max[] = array(
            "month_year" => $row['month_year']
        );
    }

    $arr['month_year_max'] = $month_year_max;


    echo json_encode($arr, JSON_PRETTY_PRINT);
} else {
    echo 'Tidak ada data';
}

mysqli_close($con);
