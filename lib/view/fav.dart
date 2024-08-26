import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            TextButton(
              child: Text('News'),
              onPressed: () {},
            ),
            SizedBox(width: 10),
            TextButton(
              child: Icon(Icons.favorite, color: Colors.red),
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue.shade100,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: 2, // Replace with actual favorite count
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Image.network('https://placeholder.com/100'),
              title: Text(
                  'Purus suspendisse adipiscing quam. Varius magnis in nisl.'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'At leo tellus ornare adipiscing adipiscing pharetra nisi ornare.'),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16),
                      SizedBox(width: 4),
                      Text('Mon, 21 Dec 2020 14:57 GMT'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
