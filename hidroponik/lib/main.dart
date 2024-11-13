import 'package:flutter/material.dart';
import 'api_service.dart';

void main() {
  runApp(SuhuApp());
}

class SuhuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Suhu',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: SuhuPage(),
    );
  }
}

class SuhuPage extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Suhu Harian",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: apiService.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Tidak ada data"));
          } else {
            final data = snapshot.data!;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: ListView(
                children: [
                  _buildStatCard("Suhu Maksimum", "${data['suhumax']} °C",
                      Colors.redAccent),
                  _buildStatCard("Suhu Minimum", "${data['suhumin']} °C",
                      Colors.blueAccent),
                  _buildStatCard("Rata-rata Suhu", "${data['suhurata']} °C",
                      Colors.orangeAccent),
                  SizedBox(height: 20),
                  Text(
                    "Data Suhu & Kelembaban Tertinggi",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo),
                  ),
                  _buildDataList(data['nilai_suhu_max_humid_max']),
                  SizedBox(height: 20),
                  Text(
                    "Bulan-Tahun Data",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo),
                  ),
                  _buildMonthYearList(data['month_year_max']),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 5,
      shadowColor: color.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(Icons.thermostat, color: color, size: 28),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800]),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataList(List<dynamic> dataList) {
    return Column(
      children: dataList.map((item) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: Icon(Icons.date_range, color: Colors.indigoAccent),
            title: Text(
              "ID: ${item['id']} - Suhu: ${item['suhu']} °C",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              "Humidity: ${item['humid']}% - ${item['timestamp']}",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMonthYearList(List<dynamic> monthYearList) {
    return Wrap(
      spacing: 8,
      children: monthYearList.map((item) {
        return Chip(
          label: Text(
            item['month_year'],
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.indigo.shade50,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        );
      }).toList(),
    );
  }
}
