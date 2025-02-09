import '../models/category.dart';

class CategoryOperations {
  CategoryOperations._();
  static List<Category> getCategories() {
    return <Category>[
      Category(
        'Piano Sounds',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUuazfSKNjsIIuG0orK9w98nJfFNLsZzEoEA&s',
      ),
      Category(
        'Guitar',
        'https://static.wixstatic.com/media/7b3597_249cec3207094999b29792967654ef3a~mv2.jpg/v1/fill/w_1000,h_622,al_c,q_85,usm_0.66_1.00_0.01/7b3597_249cec3207094999b29792967654ef3a~mv2.jpg',
      ),
      Category(
        'Violin',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFsE4jOhBORHmNWVD9vJyAKuFQhjQ8My7cFQ&s',
      ),
      Category(
        'Flute',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwUk3kXKrkiCzTn79TvwpzP0stxxdxZgkfDg&s',
      ),
      Category(
        'Nature',
        'https://static.vecteezy.com/system/resources/thumbnails/024/669/489/small_2x/mountain-countryside-landscape-at-sunset-dramatic-sky-over-a-distant-valley-green-fields-and-trees-on-hill-beautiful-natural-landscapes-of-the-carpathians-generative-ai-variation-5-photo.jpeg',
      ),
      Category(
        'Rain',
        'https://static.vecteezy.com/system/resources/previews/042/146/565/non_2x/ai-generated-beautiful-rain-day-view-photo.jpg',
      )
    ];
  }
}
