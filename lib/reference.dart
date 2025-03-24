import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
      await launchUrl(uri, mode: LaunchMode.externalApplication); // Opens in browser
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'References',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF369E40),
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              _buildBoxedSection(
                title: "Plant Information",
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
              ),
              _buildBoxedSection(
                title: "Did You Know?",
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
              ),
              const SizedBox(height: 16),
              _buildBoxedSection(
                title: "First Aid - References",
                items: [
                  ["Major Toxicity: MSD Manuals – Plant Poisoning", "https://www.msdmanuals.com/home/quick-facts-injuries-and-poisoning/poisoning/plant-poisoning"],
                  ["Minor Toxicity: WebMD – Poisonous Plants Guide", "https://www.webmd.com/skin-problems-and-treatments/ss/slideshow-poison-plants-guide"],
                  ["Oxalates: Medscape – Oxalate Poisoning Treatment", "https://emedicine.medscape.com/article/817016-treatment?form=fpf"],
                  ["Dermatitis: DermNet NZ – Plant Dermatitis", "https://dermnetnz.org/topics/plant-dermatitis"],
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

    );
  }

  // Widget to create a boxed section for reference categories
  Widget _buildBoxedSection({required String title, required List<List<String>> items, String? libraryLink}) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green.shade700, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.map((item) => _buildBulletedReference(item[0], item[1])).toList(),
          ),
          if (libraryLink != null) ...[
            const SizedBox(height: 12),
            const Divider(color: Colors.green),
            const SizedBox(height: 8),
            const Text("Descriptions:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            InkWell(
              onTap: () => _launchURL(libraryLink),
              child: Text(
                libraryLink,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Widget to display a bullet point reference item with clickable links
  Widget _buildBulletedReference(String title, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                InkWell(
                  onTap: () => _launchURL(url), // Open link in browser
                  child: Text(
                    url,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
