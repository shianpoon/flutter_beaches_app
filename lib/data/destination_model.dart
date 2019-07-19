import 'dart:core';

class DestinationModel {
  final String id;
  final String title;
  final String description;
  final List<String> imgAssetsPath;

  DestinationModel({
    this.id,
    this.title,
    this.description,
    this.imgAssetsPath,
  });
}

final List<DestinationModel> travelDestinations = [
  DestinationModel(
    id: 'Redang',
    title: 'Redang',
    description:
        'Perak\'s finest colonial architecture stands side by side with rickety kedai kopi (coffee shops) in chameleonic Ipoh.',
    imgAssetsPath: [
      'assets/img/beach1.jpg',
      'assets/img/beach2.jpg',
      'assets/img/beach3.jpeg',
    ],
  ),
  DestinationModel(
    id: 'Tioman',
    title: 'Tioman',
    description:
        'Perak\'s finest colonial architecture stands side by side with rickety kedai kopi (coffee shops) in chameleonic Ipoh.',
    imgAssetsPath: [
      'assets/img/beach2.jpg',
      'assets/img/beach1.jpg',
      'assets/img/beach3.jpeg',
    ],
  ),
  DestinationModel(
    id: 'Kapas',
    title: 'Kapas',
    description:
        'Perak\'s finest colonial architecture stands side by side with rickety kedai kopi (coffee shops) in chameleonic Ipoh.',
    imgAssetsPath: [
      'assets/img/beach3.jpeg',
      'assets/img/beach1.jpg',
      'assets/img/beach2.jpg',
    ],
  ),
  DestinationModel(
    id: 'Desaru',
    title: 'Desaru',
    description:
        'Perak\'s finest colonial architecture stands side by side with rickety kedai kopi (coffee shops) in chameleonic Ipoh.',
    imgAssetsPath: [
      'assets/img/beach4.jpg',
      'assets/img/beach2.jpg',
      'assets/img/beach3.jpeg',
    ],
  ),
];
