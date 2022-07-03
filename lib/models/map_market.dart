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

final _locations = [
  LatLng(-5.194888653491863, -80.62801801724427),
  // LatLng(12.12465294190265, -86.26758336923703),
  // LatLng(12.124735101327998, -86.2640959587788),
  // LatLng(12.12455024258537, -86.26191107511823),
  // LatLng(12.125115088341031, -86.26581865551118),
  // LatLng(12.12850539255836, -86.26769545975087),
  // LatLng(12.126449470922926, -86.27130034854444),
  // LatLng(12.13150533139753, -86.27003434593242),
];
// -5.197277446244993, -80.62909056749594
final mapMarkers = [
  MapMarker(
    image:
        'https://scontent.flim14-1.fna.fbcdn.net/v/t1.6435-9/56673235_338818493411824_139950353993957376_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=09cbfe&_nc_eui2=AeGgvxXlduwvy7zHUc41j78wQxZCO3g5CiJDFkI7eDkKIrnR9weCqYL3aiCZvAz3KLJzsXRvbX1BmWjZ2F4hWZl0&_nc_ohc=jyQM1qNhLYsAX-ESDHg&_nc_ht=scontent.flim14-1.fna&oh=00_AT9h5K36OFHCwYL8a2Uffi0jUeVysyijaf4nkfHbX0QPuw&oe=62E594DB',
    title: 'Bely boutique princess',
    address: 'C. Cusco 643, Piura 20000',
    location: _locations[0],
  ),
  // MapMarker(
  //   image:
  //       'https://static.vecteezy.com/system/resources/previews/002/004/147/large_2x/cartoon-pizza-shop-vector.jpg',
  //   title: 'Managua',
  //   address: 'Los Robles #123',
  //   location: _locations[0],
  // ),
  // MapMarker(
  //   image:
  //       'https://us.123rf.com/450wm/stuartphoto/stuartphoto1705/stuartphoto170500326/77496742-icono-de-la-tienda-de-pizza-significado-pizzer%C3%ADa-restaurante-ilustraci%C3%B3n-3d.jpg?ver=6',
  //   title: 'Managua',
  //   address: 'Los Robles #123',
  //   location: _locations[1],
  // ),
  // MapMarker(
  //   image:
  //       'https://media-cdn.tripadvisor.com/media/photo-s/16/34/5f/49/mas-de-10-anos-mejorando.jpg',
  //   title: 'Managua',
  //   address: 'Los Robles #123',
  //   location: _locations[2],
  // ),
  // MapMarker(
  //   image:
  //       'https://gruposaedal.com/wp-content/uploads/2021/10/El-inventario-de-Dominos-Pizza-cae-despues-de-que-las-1140x641.jpeg',
  //   title: 'Managua',
  //   address: 'Los Robles #123',
  //   location: _locations[3],
  // ),
  // MapMarker(
  //   image:
  //       'https://www.eventoplus.com.ar/wp-content/uploads/2022/03/190-tiendas-Papa-Johns-en-Rusia-siguen-abiertas-Al-final.jpg',
  //   title: 'Managua',
  //   address: 'Los Robles #123',
  //   location: _locations[4],
  // ),
  // MapMarker(
  //   image:
  //       'https://www.eventoplus.com.ar/wp-content/uploads/2022/03/190-tiendas-Papa-Johns-en-Rusia-siguen-abiertas-Al-final.jpg',
  //   title: 'Managua',
  //   address: 'Los Robles #123',
  //   location: _locations[5],
  // ),
  // MapMarker(
  //   image:
  //       'https://www.eventoplus.com.ar/wp-content/uploads/2022/03/190-tiendas-Papa-Johns-en-Rusia-siguen-abiertas-Al-final.jpg',
  //   title: 'Managua',
  //   address: 'Los Robles #123',
  //   location: _locations[6],
  // )
];
