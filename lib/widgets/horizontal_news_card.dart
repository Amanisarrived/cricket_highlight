// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../model/hive_news_model.dart';
//
// class HorizontalNewsCard extends StatelessWidget {
//   final Newsmodel news;
//   final VoidCallback onTap;
//
//   const HorizontalNewsCard({
//     super.key,
//     required this.news,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 180, // thoda chhota width
//         margin: const EdgeInsets.only(right: 12),
//         decoration: BoxDecoration(
//           color: Colors.grey[900],
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.redAccent.withAlpha(50),
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min, // content ke hisaab se adjust
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image
//             ClipRRect(
//               borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//               child: SizedBox(
//                 height: 80, // slightly chhota
//                 width: double.infinity,
//                 child: Image.network(
//                   news.imageUrl,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => Container(color: Colors.grey[800]),
//                 ),
//               ),
//             ),
//
//             // Title
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               child: Text(
//                 news.title,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: GoogleFonts.bebasNeue(
//                   color: Colors.white,
//                   fontSize: 12, // thoda chhota font
//                 ),
//               ),
//             ),
//
//             // Credits + Date
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       news.credits,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.inter(
//                         color: Colors.redAccent,
//                         fontSize: 9,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     "${news.createdAt.day}/${news.createdAt.month}/${news.createdAt.year}",
//                     style: GoogleFonts.inter(
//                       color: Colors.white54,
//                       fontSize: 9,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 6), // bottom padding
//           ],
//         ),
//       ),
//     );
//   }
// }
