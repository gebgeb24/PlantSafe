import 'package:flutter/material.dart';
import 'plantDetailScreen.dart'; // Import the new screen

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final List<Map<String, dynamic>> plants = [
    {
      'itemNum': '1',
      'image1': 'assets/images/library/3BC.png',
      'image2': 'assets/images/library/2BC.png',
      'image3': 'assets/images/library/1BC.png',
      'image4': 'assets/images/library/4BC.png',
      'plantName': 'Bulbous buttercup',
      'scientificName': 'Ranunculus bulbosus',
      'tagalogName': 'Dilaw-dilawan',
      'description1': "Ranunculus bulbosus, commonly known as bulbous buttercup or St. Anthony's turnip, is a perennial flowering plant in the buttercup family Ranunculaceae. It has bright yellow flowers, and deeply divided, three-lobed long-petioled basal leaves.",
      'description2': 'Flower commonly yellow, thimble like, often shiny. Cultivars in many other colors. Blooms around mid-spring and summer',
      'toxicityIndex': 'Minor & Dermatitis',
      'toxicityDescription': 'The juice, sap, or thorns of these plants may cause skin irritation, rashes, or mild illnesses such as vomiting or diarrhea.',
      'location': [
        {"latitude": 14.1250, "longitude": 121.2994, "name": "Laguna"},
        {'latitude': 16.5975, 'longitude': 120.8992, 'name': 'Benguet'},
        {'latitude': 13.9347, 'longitude': 121.9473, 'name': 'Quezon Province'},
        {'latitude': 16.3414, 'longitude': 121.9369, 'name': 'Sierra Madre'},
        {'latitude': 9.8500, 'longitude': 124.1435, 'name': 'Bohol'},
      ]
    },
    {
      'itemNum': '2',
      'image1': 'assets/images/library/2CL.png',
      'image2': 'assets/images/library/1CL.png',
      'image3': 'assets/images/library/3CL.png',
      'image4': 'assets/images/library/4CL.png',
      'plantName': 'Clematis',
      'scientificName': 'Clematis recta',
      'tagalogName': 'Bagawak',
      'description1': 'Clematis are perennials in the buttercup family (Ranunculaceae) some of which are climbers and others are spreading subshrubs or groundcovers. There are nearly 400 species and many more cultivars and hybrids. They are cosmopolitan in distribution. The genus name derives from the Greek word klēmatis, meaning broken branches, perhaps owing to its fragile stems.',
      'description2': 'Striking copper-green leaves splashed with a multitude of colors that vary between cultivars. The size ranges from 4"-8" long and usually heart-shaped with serrate margins.',
      'toxicityIndex': 'Minor & Dermatitis',
      'toxicityDescription': 'The juice, sap, or thorns of these plants may cause skin irritation, rashes, or mild illnesses such as vomiting or diarrhea.',
      "location": [
        {'latitude': 13.1775, 'longitude': 123.5280, 'name': 'Albay'},
        {'latitude': 14.136679125419535, 'longitude': 121.19435826647484, 'name': 'Laguna'},
        {'latitude': 16.8331, 'longitude': 121.1710, 'name': 'Ifugao'},
        {'latitude': 14.6091, 'longitude': 121.0223, 'name': 'Metro Manila'},
        {'latitude': 17.0663, 'longitude': 121.0335, 'name': 'Mountain Province'},
      ]
    },
    {
      'itemNum': '3',
      'image1': 'assets/images/library/1CP.png',
      'image2': 'assets/images/library/2CP.png',
      'image3': 'assets/images/library/3CP.png',
      'image4': 'assets/images/library/4CP.png',
      'plantName': 'Copperleaf',
      'scientificName': 'Acalypha wilkesiana',
      'tagalogName': 'Buntot-pusa',
      'description1': 'It has 4 to 8-inch heart-shaped leaves that come in a variety of mottled color combinations of green, purple, yellow, orange, copper, crimson, pink, or white.  Separate male and female flowers appear on the same plant, male spikes long and hanging with female spikes short.',
      'description2': 'Striking copper-green leaves splashed with a multitude of colors that vary between cultivars. The size ranges from 4"-8" long and usually heart-shaped with serrate margins.',
      'toxicityIndex': 'Minor & Dermatitis',
      'toxicityDescription': 'The juice, sap, or thorns of these plants may cause skin irritation, rashes, or mild illnesses such as vomiting or diarrhea.',
      "location": [
        {"latitude": 13.7392, "longitude": 120.9281, "name": "Batangas"},
        {"latitude": 14.1672, "longitude": 121.2431, "name": "Laguna"},
        {"latitude": 13.6303, "longitude": 123.1853, "name": "Camarines Sur"},
        {"latitude": 7.1014, "longitude": 125.6097, "name": "Davao del Sur"},
        {"latitude": 8.4844, "longitude": 124.6500, "name": "Cagayan de Oro"},
      ]
    },
    {
      'itemNum': '4',
      'image1': 'assets/images/library/1LY.png',
      'image2': 'assets/images/library/2LY.png',
      'image3': 'assets/images/library/3LY.png',
      'image4': 'assets/images/library/4LY.png',
      'plantName': 'Crinum Lily',
      'scientificName': 'Crinum asiaticum',
      'tagalogName': 'Bakong',
      'description1': 'Crinum lilies are summer-flowering bulbs in the Amaryllidaceae (amaryllis) family. They have an erect growth habit and reach 2 to 4 feet tall and wide. They are native to the tropics and subtropics of Asia, Australia, Africa, and the Americas and are sometimes called cemetery plants because, in past centuries, they were often used in cemeteries.',
      'description2': 'Lily-like flowers (to 4” wide and long), ranging in shape from bell-shaped to spider-like, bloom in clusters in summer atop leafless stalks.',
      'toxicityIndex': 'Minor & Dermatitis',
      'toxicityDescription': 'The juice, sap, or thorns of these plants may cause skin irritation, rashes, or mild illnesses such as vomiting or diarrhea.',
      "location": [
        {"latitude": 14.1250, "longitude": 121.2994, "name": "Laguna"},
        {"latitude": 9.6567, "longitude": 124.4006, "name": "Bohol"},
        {"latitude": 15.9247, "longitude": 120.2953, "name": "Pangasinan"},
        {"latitude": 14.5533, "longitude": 120.5347, "name": "Bataan"},
        {"latitude": 13.6300, "longitude": 123.3836, "name": "Camarines Sur"},
      ]
    },
    {
      'itemNum': '5',
      'image1': 'assets/images/library/1EP.png',
      'image2': 'assets/images/library/2EP.png',
      'image3': 'assets/images/library/3EP.png',
      'image4': 'assets/images/library/4EP.png',
      'plantName': 'Elephant\'s Ear',
      'scientificName': 'Colocasia esculenta',
      'tagalogName': 'Gabi',
      'description1': 'Colocasia is a genus of herbaceous perennials famed for their large foliage which come in a variety of shades and in some different patterns. Their leaves are heart-shaped, thin, and rubbery. Originating from Southeastern Asia, these plants enjoy loamy, fertile soil and tropical climates. They can be grown in full sun to part shade and make a very interesting accent to any garden and an amazing statement in any garden.',
      'description2': 'Leaves can vary in colors from green with light veins, to a more neon veins, to even dark black with pale white veins. Leaves are very large (generally up to 3 feet), arrow-shaped, and are long-stalked.',
      'toxicityIndex': 'Oxalates & Dermatitis',
      'toxicityDescription': 'The juice, sap, or thorns of these plants contain needle-shaped oxalate crystals that can irritate the skin, mouth, tongue, and throat, potentially causing a rash or irritation.',
      "location": [
        {'latitude': 13.1775, 'longitude': 123.5280, 'name': 'Albay'},
        {'latitude': 14.136679125419535, 'longitude': 121.19435826647484, 'name': 'Laguna'},
        {'latitude': 16.8331, 'longitude': 121.1710, 'name': 'Ifugao'},
        {'latitude': 14.6091, 'longitude': 121.0223, 'name': 'Metro Manila'},
        {'latitude': 17.0663, 'longitude': 121.0335, 'name': 'Mountain Province'},
      ]
    },
    {
      'itemNum': '6',
      'image1': 'assets/images/library/1FT.png',
      'image2': 'assets/images/library/2FT.png',
      'image3': 'assets/images/library/3FT.png',
      'image4': 'assets/images/library/4FT.png',
      'plantName': 'Fishtail Palm',
      'scientificName': 'Caryota mitis',
      'tagalogName': 'Pugahan',
      'description1': 'The fishtail palm is a member of the palm family (Arecaceae) from Southeast Asia, where it is most often found in moist organic soil over limestone in mesic hammocks and disturbed wooded areas. The genus name is from the Greek, karuotos, meaning “nut-bearing.” The species epithet is a Latin word meaning “mild” or “unarmed.”',
      'description2': 'Leaves are large, long-stalked, arching, bipinnately divided into leaflets which are widest above the middle and irregularly toothed at apex. The leaves are large at 6 1/2 to 13 feet long.',
      'toxicityIndex': 'Oxalates & Dermatitis',
      'toxicityDescription': 'The juice, sap, or thorns of these plants contain needle-shaped oxalate crystals that can irritate the skin, mouth, tongue, and throat, potentially causing a rash or irritation.',
      "location": [
        {'latitude': 13.1775, 'longitude': 123.5280, 'name': 'Albay'},
        {'latitude': 14.136679125419535, 'longitude': 121.19435826647484, 'name': 'Laguna'},
        {'latitude': 16.8331, 'longitude': 121.1710, 'name': 'Ifugao'},
        {'latitude': 14.6091, 'longitude': 121.0223, 'name': 'Metro Manila'},
        {'latitude': 17.0663, 'longitude': 121.0335, 'name': 'Mountain Province'
        },
      ]
    },
    {
      'itemNum': '7',
      'image1': 'assets/images/library/1HY.png',
      'image2': 'assets/images/library/2HY.png',
      'image3': 'assets/images/library/3HY.png',
      'image4': 'assets/images/library/4HY.png',
      'plantName': 'Hydrangea',
      'scientificName': 'Hydrangea macrophylla',
      'tagalogName': 'Hortensia',
      'description1': 'Hydrangeas are deciduous shrubs with flowers in terminal, round or umbrella-shaped clusters in colors of white, pink, or blue, or even purple. If they flower blue, your soil is acidic (having less than 5.5 pH) and if they bloom pink, your soil is alkaline (higher than 6.5 pH).  If your soil is between acidic and alkaline, then you will probably have purple flowers.',
      'description2': 'Terminal, round or umbrella-shaped corymb clusters in colors of white, pink, or blue (or sometimes purple).',
      'toxicityIndex': 'Major & Dermatitis',
      'toxicityDescription': 'Ingesting or touching these plants can cause serious illness or death, along with painful skin rashes or irritation.',
      "location": [
        {"latitude": 16.4140, "longitude": 120.6133, "name": "Baguio"},
        {"latitude": 10.4058, "longitude": 123.8656, "name": "Cebu"},
        {"latitude": 14.5549, "longitude": 121.2842, "name": "Antipolo"},
        {"latitude": 16.1975, "longitude": 121.6689, "name": "Quirino Province"},
        {"latitude": 10.6964, "longitude": 123.1767, "name": "Negros Occidental"},
      ]
    },
    {
      'itemNum': '8',
      'image1': 'assets/images/library/1IR.png',
      'image2': 'assets/images/library/2IR.png',
      'image3': 'assets/images/library/3IR.png',
      'image4': 'assets/images/library/4IR.png',
      'plantName': 'Iris',
      'scientificName': 'Trimezia coerulea',
      'tagalogName': 'Lirio',
      'description1': 'The Iris is one of the most popular perennials and is available in a variety of colors with varying blooming times. The family Iridaceae is a very large one of perennial herbaceous herbs growing from a rhizome, corm, or bulb. There are Iris varieties native throughout the world that offers the possibility of use in a native or woodland garden.',
      'description2': 'The leaves are green to bluish-green, and blades, swords, or fans of foliage. They have parallel leaf veins. Range in size from 6 inches to 2 feet and are arranged in clumps.',
      'toxicityIndex': 'Minor & Dermatitis',
      'toxicityDescription': 'The juice, sap, or thorns of these plants may cause skin irritation, rashes, or mild illnesses such as vomiting or diarrhea.',
      "location": [
        {'latitude': 13.1775, 'longitude': 123.5280, 'name': 'Albay'},
        {'latitude': 14.136679125419535, 'longitude': 121.19435826647484, 'name': 'Laguna'},
        {'latitude': 16.8331, 'longitude': 121.1710, 'name': 'Ifugao'},
        {'latitude': 14.6091, 'longitude': 121.0223, 'name': 'Metro Manila'},
        {'latitude': 17.0663, 'longitude': 121.0335, 'name': 'Mountain Province'},
      ]
    },
    {
      'itemNum': '9',
      'image1': 'assets/images/library/1PH.png',
      'image2': 'assets/images/library/2PH.png',
      'image3': 'assets/images/library/3PH.png',
      'image4': 'assets/images/library/4PH.png',
      'plantName': 'Pothos',
      'scientificName': 'Epipremnum Aureum',
      'tagalogName': 'Dilang-baka',
      'description1': 'Pothos is a low-maintenance, perennial, broadleaf evergreen houseplant in the Araceae (arum) family and desired for its glossy, green or variegated leaves on cascading stems.It grows only 6 to 8 feet as a horizontal groundcover, but the trailing and climbing vines can grow as long as 40 feet. As a container plant, it generally retains its juvenile leaf shape.',
      'description2': 'Leaves heart-shaped to elliptic-ovate, glossy medium green variegated with paler green underside. Veins may be reddish.',
      'toxicityIndex': 'Oxalates & Dermatitis',
      'toxicityDescription': 'The juice, sap, or thorns of these plants contain needle-shaped oxalate crystals that can irritate the skin, mouth, tongue, and throat, potentially causing a rash or irritation.',
      "location": [
        {"latitude": 15.1239, "longitude": 120.5820, "name": "Pampanga"},
        {"latitude": 14.6389, "longitude": 121.0758, "name": "QC"},
        {"latitude": 14.5767, "longitude": 121.1581, "name": "Taytay"},
        {"latitude": 13.7531, "longitude": 121.0503, "name": "Batangas"},
        {"latitude": 10.6792, "longitude": 122.9631, "name": "Bacolod"},
      ]
    },
    {
      'itemNum': '10',
      'image1': 'assets/images/library/1SN.png',
      'image2': 'assets/images/library/2SN.png',
      'image3': 'assets/images/library/3SN.png',
      'image4': 'assets/images/library/4SN.png',
      'plantName': 'Stinging Nettle',
      'scientificName': 'Urtica dioica',
      'tagalogName': 'Lipang Aso',
      'description1': "Stinging Nettle is a perennial herb growing nearly worldwide. It occurs in moist sites along streams, meadow, and ditches, on mountain slopes, in woodland clearings, and in disturbed areas.  Stinging nettle generally grows on deep, rich, moist soil and doesn't do well in areas of drought. Stinging Nettle reproduces by rhizomes and seeds and can form dense colonies covering and an acre or more. It is considered a noxious weed in some areas.",
      'description2': '1”-6” simple opposite saw-tooth margin egg-shaped green leaves with a heart-shaped base and a pointed tip with hairs and stinging hairs.',
      'toxicityIndex': 'Dermatitis',
      'toxicityDescription': 'The juice, sap, or thorns of these plants may cause a skin rash or irritation.',
      'location': [
        {"latitude": 13.7444, "longitude": 121.0839, "name": "Batangas"},
        {"latitude": 10.4783, "longitude": 123.1036, "name": "Negros Occidental"},
        {"latitude": 14.1561, "longitude": 121.2342, "name": "Laguna"},
        {"latitude": 8.3886, "longitude": 123.1689, "name": "Zamboanga del Norte"},
        {"latitude": 7.5231, "longitude": 122.3108, "name": "Zamboanga Sibugay"},
      ]
    },

    // Add more plants here
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    // Filter the plants list based on the search query
    final filteredPlants = plants.where((plant) {
      final query = searchQuery.toLowerCase();
      return plant['plantName']!.toLowerCase().contains(query) ||
          plant['scientificName']!.toLowerCase().contains(query) ||
          plant['tagalogName']!.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Library',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4FAE50),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFE9FFC8),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Image.asset(
                'assets/images/logo.jpg',
                width: screenWidth * 0.9,
              ),
            ),
            const Text(
              'Beware of these\nplants',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFFe2a52a),
                shadows: [
                  Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 3.0,
                    color: Color(0x80000000),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFf1f1f1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (filteredPlants.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'Cannot be found.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: filteredPlants.length,
                  itemBuilder: (context, index) {
                    final plant = filteredPlants[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => plantDetailScreen(plant: plant),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFF08411c),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  plant['image1']!,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      plant['plantName']!,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      plant['scientificName']!,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(
                                      'Also known as ${plant['tagalogName']}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
