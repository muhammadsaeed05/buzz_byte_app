import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_app/data/models/news_response_model.dart';
import 'package:news_app/domain/entities/app_error.dart';
import 'package:news_app/domain/entities/article_entity.dart';
import 'package:news_app/presentation/blocs/bloc/news_bloc.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetEverythingUseCase mockGetEverythingUseCase;
  late NewsBloc newsBloc;

  var testArticlesEntity = [
    ArticleEntity(
        author: "Me",
        content: "Hello",
        description: "Hello world",
        publishedAt: DateTime.now(),
        source: const Source(id: Id.GOOGLE_NEWS, name: "Google News"),
        title: "Hello",
        url: "www.hello.com",
        urlToImage: "www.hello.com")
  ];

  setUp(() {
    mockGetEverythingUseCase = MockGetEverythingUseCase();
    newsBloc = NewsBloc(mockGetEverythingUseCase);
  });

  test('initial state should be empty', () {
    expect(newsBloc.state, NewsInitial());
  });

  blocTest<NewsBloc, NewsState>(
    'emits [NewsLoading, NewsLoaded] when LoadNewsEvent is added.',
    build: () {
      when(mockGetEverythingUseCase())
          .thenAnswer((_) async => Right(testArticlesEntity));
      return newsBloc;
    },
    act: (bloc) => bloc.add(LoadNewsEvent()),
    expect: () => [NewsLoading(), NewsLoaded(testArticlesEntity)],
  );

  blocTest<NewsBloc, NewsState>(
    'emits [NewsLoading, NewsError] when LoadNewsEvent is added.',
    build: () {
      when(mockGetEverythingUseCase())
          .thenAnswer((_) async => Left(const AppError(AppErrorType.api)));
      return newsBloc;
    },
    act: (bloc) => bloc.add(LoadNewsEvent()),
    expect: () => [NewsLoading(), const NewsError(AppErrorType.api)],
  );
}
