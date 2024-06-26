import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class Team {
  final String id;
  final String name;
  final List<Player> players;

  Team({required this.id, required this.name, required this.players});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      players: (json['players'] as List).map((playerJson) => Player.fromJson(playerJson)).toList(),
    );
  }
}

class Player {
  final String id;
  final String name;
  final String position;
  final String imageUrl;

  Player({required this.id, required this.name, required this.position, required this.imageUrl});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      imageUrl: json['imageUrl'],
    );
  }
}

class ApiService {
  Future<List<Team>> getTeams() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    List<dynamic> data = [
      {
        'id': '1',
        'name': 'Galatasaray',
        'players': [
          {'id': '1', 'name': 'Fernando Muslera', 'position': 'Kaleci', 'imageUrl': ''},
          {'id': '2', 'name': 'Arda Turan', 'position': 'Orta Saha', 'imageUrl': ''},
        ],
      },
      {
        'id': '2',
        'name': 'Fenerbahçe',
        'players': [
          {'id': '1', 'name': 'Altay Bayındır', 'position': 'Kaleci', 'imageUrl': ''},
          {'id': '2', 'name': 'Mesut Özil', 'position': 'Orta Saha', 'imageUrl': ''},
        ],
      },
      {
        'id': '3',
        'name': 'Beşiktaş',
        'players': [
          {'id': '1', 'name': 'Ersin Destanoğlu', 'position': 'Kaleci', 'imageUrl': ''},
          {'id': '2', 'name': 'Josef de Souza', 'position': 'Orta Saha', 'imageUrl': ''},
        ],
      },
      {
        'id': '4',
        'name': 'Trabzonspor',
        'players': [
          {'id': '1', 'name': 'Uğurcan Çakır', 'position': 'Kaleci', 'imageUrl': ''},
          {'id': '2', 'name': 'Anastasios Bakasetas', 'position': 'Orta Saha', 'imageUrl': ''},
        ],
      },
    ];
    return data.map((teamJson) => Team.fromJson(teamJson)).toList();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Football Teams',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TeamScreen(),
    );
  }
}

class TeamScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Takımlar'),
      ),
      body: FutureBuilder<List<Team>>(
        future: apiService.getTeams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata oluştu: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Takım bulunamadı.'));
          }

          List<Team> teams = snapshot.data!;

          return ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(teams[index].name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerScreen(team: teams[index]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class PlayerScreen extends StatelessWidget {
  final Team team;

  PlayerScreen({required this.team});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${team.name} Oyuncuları'),
      ),
      body: ListView.builder(
        itemCount: team.players.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(team.players[index].name),
            subtitle: Text(team.players[index].position),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerDetailScreen(player: team.players[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PlayerDetailScreen extends StatelessWidget {
  final Player player;

  PlayerDetailScreen({required this.player});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(player.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text('Pozisyon: ${player.position}', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}