import 'package:latlong2/latlong.dart';

class MapMarker {
  final String image;
  final String title;
  final String address;
  final LatLng location;
  MapMarker({
    required this.image,
    required this.title,
    required this.address,
    required this.location,
  });
}
// LOCATION DEF
final _locations = [
  LatLng(-5.194888653491863, -80.62801801724427),
];
final mapMarkers = [
  MapMarker(
    image:
        'https://scontent.flim14-1.fna.fbcdn.net/v/t1.6435-9/56673235_338818493411824_139950353993957376_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=09cbfe&_nc_eui2=AeGgvxXlduwvy7zHUc41j78wQxZCO3g5CiJDFkI7eDkKIrnR9weCqYL3aiCZvAz3KLJzsXRvbX1BmWjZ2F4hWZl0&_nc_ohc=jyQM1qNhLYsAX-ESDHg&_nc_ht=scontent.flim14-1.fna&oh=00_AT9h5K36OFHCwYL8a2Uffi0jUeVysyijaf4nkfHbX0QPuw&oe=62E594DB',
    title: 'Bely boutique princess',
    address: 'C. Cusco 643, Piura 20000',
    location: _locations[0],
  ),
];
