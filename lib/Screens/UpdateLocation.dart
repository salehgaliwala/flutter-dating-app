import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:flutter_mapbox_autocomplete/flutter_mapbox_autocomplete.dart';
import 'package:seting/Screens/seach_location.dart';
import 'package:seting/util/color.dart';
import 'package:location/location.dart' as loc;
import 'package:easy_localization/easy_localization.dart';

class UpdateLocation extends StatefulWidget {
  @override
  _UpdateLocationState createState() => _UpdateLocationState();
}

class _UpdateLocationState extends State<UpdateLocation> {
  late Map _newAddress;
  GeoCode geoCode = GeoCode();
  @override
  void initState() {
    getLocationCoordinates(geoCode).then((updateAddress) {
      setState(() {
        _newAddress = updateAddress!;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: ListTile(
          title: Text(
            "Use current location".tr().toString(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(_newAddress != null
              ? _newAddress['PlaceName'] ?? 'Fetching..'.tr().toString()
              : 'Unable to load...'.tr().toString()),
          leading: const Icon(
            Icons.location_searching_rounded,
            color: Colors.white,
          ),
          onTap: () async {
            if (_newAddress == null) {
              await getLocationCoordinates(geoCode).then((updateAddress) {
                print(updateAddress);
                setState(() {
                  _newAddress = updateAddress!;
                });
              });
            } else {
              print("-------object");
              Navigator.pop(context, _newAddress);
            }
          },
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * .6,
        child: MapBoxAutoCompleteWidget(
          language: 'en',
          closeOnSelect: false,
          apiKey: mapboxApi,
          limit: 10,
          hint: 'Enter your city name'.tr().toString(),
          onSelect: (place) {
            Map obj = {};
            obj['PlaceName'] = place.placeName;
            obj['latitude'] = place.geometry!.coordinates![1];
            obj['longitude'] = place.geometry!.coordinates![0];
            Navigator.pop(context, obj);
          },
        ),
      ),
    );
  }
}

Future<Map?> getLocationCoordinates(GeoCode geocode) async {
  loc.Location location = loc.Location();
  try {
    await location.serviceEnabled().then((value) async {
      if (!value) {
        await location.requestService();
      }
    });
    final coordinates = await location.getLocation();
    return await coordinatesToAddress(
      latitude: coordinates.latitude,
      longitude: coordinates.longitude,
    );
  } catch (e) {
    print(e);
    return null;
  }
}

Future coordinatesToAddress({latitude, longitude}) async {
  GeoCode geoCode = GeoCode();
  try {
    Map<String, dynamic> obj = {};
    final coordinates = Coordinates(latitude: latitude,longitude: longitude);
    Address result =
        await geoCode.reverseGeocoding(latitude: latitude, longitude: longitude);
    String currentAddress =
        "${result.streetAddress ?? ''} ${result.city ?? ''} ${result.region ?? ''} ${result.countryName ?? ''}, ${result.postal ?? ''}";

    print(currentAddress);
    obj['PlaceName'] = currentAddress;
    obj['latitude'] = latitude;
    obj['longitude'] = longitude;

    return obj;
  } catch (_) {
    print(_);
    return null;
  }
}
