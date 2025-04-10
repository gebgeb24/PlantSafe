import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class ReferenceScreen extends StatefulWidget {
  const ReferenceScreen({super.key});

  @override
  _ReferenceScreenState createState() => _ReferenceScreenState();
}

class _ReferenceScreenState extends State<ReferenceScreen> {
  // Function to open links in an external browser
  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'References',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF4FAE50), // Deeper green
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,

      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: ListView(
            children: [
              const SizedBox(height: 16),
              _buildBoxedSection(
                title: "Plant Information",
                icon: Icons.local_florist,
                items: [
                  ["Bulbous Buttercup", "https://www.worldfloraonline.org/taxon/wfo-0000461562"],
                  ["Clematis", "https://www.worldfloraonline.org/taxon/wfo-0000610576"],
                  ["Copperleaf", "https://www.worldfloraonline.org/taxon/wfo-0000254905"],
                  ["Crinum Lily", "https://www.worldfloraonline.org/taxon/wfo-0000772192"],
                  ["Elephant’s Ear", "https://www.worldfloraonline.org/taxon/wfo-0000917419"],
                  ["Fishtail Palm", "https://www.worldfloraonline.org/taxon/wfo-0000809552"],
                  ["Hydrangea", "https://www.worldfloraonline.org/taxon/wfo-0000726228"],
                  ["Pothos", "https://www.worldfloraonline.org/taxon/wfo-0000952367"],
                  ["Stinging Nettle", "https://www.worldfloraonline.org/taxon/wfo-0000416616"],
                  ["Walking Iris", "https://www.worldfloraonline.org/taxon/wfo-0000786770"]
                ],
                libraryLink: "https://plants.ces.ncsu.edu/",
                showAll: true,
              ),
              const SizedBox(height: 20),
              _buildBoxedSection(
                title: "Did You Know?",
                icon: Icons.lightbulb_outline,
                items: [
                  ["Bulbous Buttercup", "https://facts.net/nature/plants/13-astounding-facts-about-buttercup/"],
                  ["Clematis", "https://facts.net/nature/plants/17-extraordinary-facts-about-clematis/"],
                  ["Copperleaf", "https://gardenbeast.com/copper-plant-guide/"],
                  ["Crinum Lily", "https://facts.net/nature/plants/19-intriguing-facts-about-crinum-lily/"],
                  ["Elephant’s Ear", "https://www.akronzoo.org/plant/elephant-ear#:~:text=Fun%20Fact,toxic%20to%20children%20or%20pets."],
                  ["Fishtail Palm", "https://thehouseplantguru.com/2022/08/17/fishtail-palms-flower-from-the-top-of-the-plant-to-the-bottom/#google_vignette"],
                  ["Hydrangea", "https://www.bhg.com/gardening/trees-shrubs-vines/shrubs/hydrangea-facts/"],
                  ["Iris", "https://facts.net/nature/plants/18-unbelievable-facts-about-iris/"],
                  ["Pothos", "https://facts.net/nature/plants/20-captivating-facts-about-pothos/"],
                  ["Stinging Nettle", "https://www.wildlifetrusts.org/wildlife-explorer/wildflowers/stinging-nettle#:~:text=Did%20you%20know%3F,dark%20green%20dye%20for%20camouflage."]
                ],
                showAll: true,
              ),
              const SizedBox(height: 20),
              _buildBoxedSection(
                title: "First Aid References",
                icon: Icons.healing,
                items: [
                  ["Major Toxicity: MSD Manuals", "https://www.msdmanuals.com/home/quick-facts-injuries-and-poisoning/poisoning/plant-poisoning"],
                  ["Minor Toxicity: WebMD Guide", "https://www.webmd.com/skin-problems-and-treatments/ss/slideshow-poison-plants-guide"],
                  ["Oxalates: Medscape Treatment", "https://emedicine.medscape.com/article/817016-treatment?form=fpf"],
                  ["Dermatitis: DermNet NZ", "https://dermnetnz.org/topics/plant-dermatitis"],
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1B5E20),
        ),
      ),
    );
  }

  // Widget to create a modern boxed section for reference categories
  Widget _buildBoxedSection({
    required String title,
    required List<List<String>> items,
    String? libraryLink,
    bool showAll = false,
    required IconData icon,
  }) {
    // Display only first 5 items if there are more and showAll is false
    final displayItems = showAll ? items : (items.length > 5 ? items.sublist(0, 5) : items);
    final hasMore = !showAll && items.length > 5;

    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Section content
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...displayItems.map((item) => _buildModernReference(item[0], item[1])),

                // Show "See More" button if there are more items
                if (hasMore)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          // See more functionality would be implemented here
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF2E7D32),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "See all ${items.length} items",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Display library link if provided
                if (libraryLink != null) ...[
                  const Divider(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.link, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        "Reference Library:",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () => _launchURL(libraryLink),
                    child: Text(
                      libraryLink,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF1976D2),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget to display a modern reference item with clickable links
  Widget _buildModernReference(String title, String url) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.open_in_new,
                size: 18,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => _launchURL(url),
                    child: Text(
                      _formatUrl(url),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF1976D2),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to format URLs for display
  String _formatUrl(String url) {
    // Remove https:// and www. for cleaner display
    String displayUrl = url.replaceAll(RegExp(r'https?://'), '');
    displayUrl = displayUrl.replaceAll(RegExp(r'^www\.'), '');

    // Truncate if too long
    if (displayUrl.length > 30) {
      return displayUrl.substring(0, 30) + '...';
    }
    return displayUrl;
  }
}