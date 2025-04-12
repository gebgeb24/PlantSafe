import 'package:flutter/material.dart';
import 'dart:ui';
import 'plantDetailScreen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> plants = [
    // All the existing plant data remains the same
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
  ];

  String searchQuery = '';
  String selectedCategory = 'All Plants';
  late AnimationController _animationController;
  late Animation<double> _animation;
  final _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    setState(() {
      searchQuery = '';
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Filter the plants list based on the search query and selected category
    final filteredPlants = plants.where((plant) {
      // Filter by search query
      final matchesSearch = plant['plantName']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
          plant['scientificName']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
          plant['tagalogName']!.toLowerCase().contains(searchQuery.toLowerCase());

      // Filter by selected category
      final matchesCategory = selectedCategory == 'All Plants' ||
          (selectedCategory == 'Minor Toxicity' && plant['toxicityIndex']!.contains('Minor')) ||
          (selectedCategory == 'Major Toxicity' && plant['toxicityIndex']!.contains('Major')) ||
          (selectedCategory == 'Oxalates' && plant['toxicityIndex']!.contains('Oxalates')) ||
          (selectedCategory == 'Dermatitis' &&
              (plant['toxicityIndex']!.contains('Dermatitis') ||
                  plant['toxicityIndex'] == 'Dermatitis'));

      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF4FAE50), // Background color for the entire container
          borderRadius: BorderRadius.circular(8),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Animated App Bar with back button
              // Animated App Bar with back button
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -1),
                  end: Offset.zero,
                ).animate(_animation),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Align start for back button
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8), // Adds padding around the icon
                          decoration: const BoxDecoration(
                            color: Color(0xFF4FAE50), // Your background color for the circle
                            shape: BoxShape.circle, // Makes the container circular
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      // Center the text with a Spacer widget
                      const Spacer(), // This will push the text to the center
                      const Text(
                        'Library',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(), // This will also balance out the space after the text
                    ],
                  ),
                ),
              ),






              // Main Content
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Container(
                    color: Colors.white,
                    child: FadeTransition(
                      opacity: _animation,
                      child: Column(
                        children: [
                          // Warning Banner
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF9500), Color(0xFFFFB700)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF9500).withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Caution!',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Plants in this library may be harmful if touched or ingested.',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            height: 1.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Search Bar
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 2,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: (value) {
                                  setState(() {
                                    searchQuery = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search toxic plants...',
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade400,
                                  ),
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    color: Colors.grey.shade500,
                                  ),
                                  suffixIcon: searchQuery.isNotEmpty
                                      ? IconButton(
                                    icon: Icon(
                                      Icons.clear_rounded,
                                      color: Colors.grey.shade500,
                                    ),
                                    onPressed: _clearSearch,
                                  )
                                      : null,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 20,
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),

                          // Plant Categories
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: SizedBox(
                              height: 40,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  _buildCategoryChip('All Plants'),
                                  _buildCategoryChip('Major Toxicity'),
                                  _buildCategoryChip('Minor Toxicity'),
                                  _buildCategoryChip('Oxalates'),
                                  _buildCategoryChip('Dermatitis'),
                                ],
                              ),
                            ),
                          ),

                          // Plant Cards
                          Expanded(
                            child: filteredPlants.isEmpty
                                ? LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).viewInsets.bottom,
                                  ),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                                    child: IntrinsicHeight(
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.search_off_rounded,
                                              size: 80,
                                              color: Colors.grey.shade400,
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'No plants found',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Try adjusting your search',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                                : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              itemCount: filteredPlants.length,
                              itemBuilder: (context, index) {
                                final plant = filteredPlants[index];
                                return Hero(
                                  tag: 'plant-${plant['itemNum']}',
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => plantDetailScreen(plant: plant),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE6E6E6)
                                        ,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          // Plant Image
                                          ClipRRect(
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              bottomLeft: Radius.circular(20),
                                            ),
                                            child: Container(
                                              width: 130,
                                              height: 170,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(plant['image1']!),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),

                                            ),
                                          ),

                                          // Plant Info
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    plant['plantName']!,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF2E5729),
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    plant['scientificName']!,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontStyle: FontStyle.italic,
                                                      color: Colors.grey.shade700,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        plant['tagalogName']!,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey.shade600,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: _getToxicityColor(plant['toxicityIndex']).withOpacity(0.1),
                                                      borderRadius: BorderRadius.circular(30),
                                                    ),
                                                    child: Text(
                                                      plant['toxicityIndex']!,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500,
                                                        color: _getToxicityColor(plant['toxicityIndex']),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    bool isSelected = selectedCategory == label;
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedCategory = label;
          });
        },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF3BB44A) : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected ? const Color(0xFF3BB44A) : Colors.grey.shade300,
              width: 1,
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: const Color(0xFF3BB44A).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }

  Color _getToxicityColor(String toxicityIndex) {
    if (toxicityIndex.contains('Major')) {
      return Colors.red;
    } else if (toxicityIndex.contains('Minor')) {
      return Colors.orange;
    } else if (toxicityIndex.contains('Oxalates')) {
      return Colors.purple;
    } else {
      return Colors.amber; // For Dermatitis
    }
  }

  Widget _getToxicityOverlay(String toxicityIndex) {
    Color overlayColor = _getToxicityColor(toxicityIndex);
    IconData iconData;

    if (toxicityIndex.contains('Major')) {
      iconData = Icons.dangerous;
    } else if (toxicityIndex.contains('Minor')) {
      iconData = Icons.warning_amber;
    } else if (toxicityIndex.contains('Oxalates')) {
      iconData = Icons.science;
    } else {
      iconData = Icons.healing; // For Dermatitis
    }

    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: overlayColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              color: Colors.white,
              size: 12,
            ),
            const SizedBox(width: 4),
            Text(
              toxicityIndex.split(' & ')[0],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}