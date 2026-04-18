// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMathHistoryCollection on Isar {
  IsarCollection<MathHistory> get mathHistorys => this.collection();
}

const MathHistorySchema = CollectionSchema(
  name: r'MathHistory',
  id: -6175213122812162289,
  properties: {
    r'geometryScene': PropertySchema(
      id: 0,
      name: r'geometryScene',
      type: IsarType.object,
      target: r'GeometrySceneEmbedded',
    ),
    r'latexResult': PropertySchema(
      id: 1,
      name: r'latexResult',
      type: IsarType.string,
    ),
    r'ocrContent': PropertySchema(
      id: 2,
      name: r'ocrContent',
      type: IsarType.string,
    ),
    r'originalImagePath': PropertySchema(
      id: 3,
      name: r'originalImagePath',
      type: IsarType.string,
    ),
    r'solutionMarkdown': PropertySchema(
      id: 4,
      name: r'solutionMarkdown',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 5,
      name: r'timestamp',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _mathHistoryEstimateSize,
  serialize: _mathHistorySerialize,
  deserialize: _mathHistoryDeserialize,
  deserializeProp: _mathHistoryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'GeometrySceneEmbedded': GeometrySceneEmbeddedSchema,
    r'ViewportEmbedded': ViewportEmbeddedSchema,
    r'GeometryElementEmbedded': GeometryElementEmbeddedSchema
  },
  getId: _mathHistoryGetId,
  getLinks: _mathHistoryGetLinks,
  attach: _mathHistoryAttach,
  version: '3.1.0+1',
);

int _mathHistoryEstimateSize(
  MathHistory object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.geometryScene;
    if (value != null) {
      bytesCount += 3 +
          GeometrySceneEmbeddedSchema.estimateSize(
              value, allOffsets[GeometrySceneEmbedded]!, allOffsets);
    }
  }
  bytesCount += 3 + object.latexResult.length * 3;
  bytesCount += 3 + object.ocrContent.length * 3;
  bytesCount += 3 + object.originalImagePath.length * 3;
  bytesCount += 3 + object.solutionMarkdown.length * 3;
  return bytesCount;
}

void _mathHistorySerialize(
  MathHistory object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<GeometrySceneEmbedded>(
    offsets[0],
    allOffsets,
    GeometrySceneEmbeddedSchema.serialize,
    object.geometryScene,
  );
  writer.writeString(offsets[1], object.latexResult);
  writer.writeString(offsets[2], object.ocrContent);
  writer.writeString(offsets[3], object.originalImagePath);
  writer.writeString(offsets[4], object.solutionMarkdown);
  writer.writeDateTime(offsets[5], object.timestamp);
}

MathHistory _mathHistoryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MathHistory();
  object.geometryScene = reader.readObjectOrNull<GeometrySceneEmbedded>(
    offsets[0],
    GeometrySceneEmbeddedSchema.deserialize,
    allOffsets,
  );
  object.id = id;
  object.latexResult = reader.readString(offsets[1]);
  object.ocrContent = reader.readString(offsets[2]);
  object.originalImagePath = reader.readString(offsets[3]);
  object.solutionMarkdown = reader.readString(offsets[4]);
  object.timestamp = reader.readDateTime(offsets[5]);
  return object;
}

P _mathHistoryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectOrNull<GeometrySceneEmbedded>(
        offset,
        GeometrySceneEmbeddedSchema.deserialize,
        allOffsets,
      )) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _mathHistoryGetId(MathHistory object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _mathHistoryGetLinks(MathHistory object) {
  return [];
}

void _mathHistoryAttach(
    IsarCollection<dynamic> col, Id id, MathHistory object) {
  object.id = id;
}

extension MathHistoryQueryWhereSort
    on QueryBuilder<MathHistory, MathHistory, QWhere> {
  QueryBuilder<MathHistory, MathHistory, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MathHistoryQueryWhere
    on QueryBuilder<MathHistory, MathHistory, QWhereClause> {
  QueryBuilder<MathHistory, MathHistory, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MathHistoryQueryFilter
    on QueryBuilder<MathHistory, MathHistory, QFilterCondition> {
  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      geometrySceneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'geometryScene',
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      geometrySceneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'geometryScene',
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      latexResultEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latexResult',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      latexResultGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latexResult',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      latexResultLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latexResult',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      latexResultBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latexResult',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      latexResultStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'latexResult',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      latexResultEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'latexResult',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      latexResultContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'latexResult',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      latexResultMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'latexResult',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      latexResultIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latexResult',
        value: '',
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      latexResultIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'latexResult',
        value: '',
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      ocrContentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ocrContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      ocrContentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ocrContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      ocrContentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ocrContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      ocrContentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ocrContent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      ocrContentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ocrContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      ocrContentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ocrContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      ocrContentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ocrContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      ocrContentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ocrContent',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      ocrContentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ocrContent',
        value: '',
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      ocrContentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ocrContent',
        value: '',
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      originalImagePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      originalImagePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      originalImagePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      originalImagePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalImagePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      originalImagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originalImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      originalImagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originalImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      originalImagePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      originalImagePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalImagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      originalImagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalImagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      originalImagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalImagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      solutionMarkdownEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'solutionMarkdown',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      solutionMarkdownGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'solutionMarkdown',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      solutionMarkdownLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'solutionMarkdown',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      solutionMarkdownBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'solutionMarkdown',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      solutionMarkdownStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'solutionMarkdown',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      solutionMarkdownEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'solutionMarkdown',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      solutionMarkdownContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'solutionMarkdown',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      solutionMarkdownMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'solutionMarkdown',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      solutionMarkdownIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'solutionMarkdown',
        value: '',
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      solutionMarkdownIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'solutionMarkdown',
        value: '',
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition>
      timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MathHistoryQueryObject
    on QueryBuilder<MathHistory, MathHistory, QFilterCondition> {
  QueryBuilder<MathHistory, MathHistory, QAfterFilterCondition> geometryScene(
      FilterQuery<GeometrySceneEmbedded> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'geometryScene');
    });
  }
}

extension MathHistoryQueryLinks
    on QueryBuilder<MathHistory, MathHistory, QFilterCondition> {}

extension MathHistoryQuerySortBy
    on QueryBuilder<MathHistory, MathHistory, QSortBy> {
  QueryBuilder<MathHistory, MathHistory, QAfterSortBy> sortByLatexResult() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latexResult', Sort.asc);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterSortBy> sortByLatexResultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latexResult', Sort.desc);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterSortBy> sortByOcrContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ocrContent', Sort.asc);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterSortBy> sortByOcrContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ocrContent', Sort.desc);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterSortBy>
      sortByOriginalImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalImagePath', Sort.asc);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterSortBy>
      sortByOriginalImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalImagePath', Sort.desc);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterSortBy>
      sortBySolutionMarkdown() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'solutionMarkdown', Sort.asc);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterSortBy>
      sortBySolutionMarkdownDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'solutionMarkdown', Sort.desc);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterSortBy> sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension MathHistoryQuerySortThenBy
    on QueryBuilder<MathHistory, MathHistory, QSortThenBy> {
  QueryBuilder<MathHistory, MathHistory, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterSortBy> thenByLatexResult() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latexResult', Sort.asc);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterSortBy> thenByLatexResultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latexResult', Sort.desc);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterSortBy> thenByOcrContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ocrContent', Sort.asc);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterSortBy> thenByOcrContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ocrContent', Sort.desc);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterSortBy>
      thenByOriginalImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalImagePath', Sort.asc);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterSortBy>
      thenByOriginalImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalImagePath', Sort.desc);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterSortBy>
      thenBySolutionMarkdown() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'solutionMarkdown', Sort.asc);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterSortBy>
      thenBySolutionMarkdownDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'solutionMarkdown', Sort.desc);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QAfterSortBy> thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension MathHistoryQueryWhereDistinct
    on QueryBuilder<MathHistory, MathHistory, QDistinct> {
  QueryBuilder<MathHistory, MathHistory, QDistinct> distinctByLatexResult(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latexResult', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QDistinct> distinctByOcrContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ocrContent', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QDistinct> distinctByOriginalImagePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalImagePath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QDistinct> distinctBySolutionMarkdown(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'solutionMarkdown',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MathHistory, MathHistory, QDistinct> distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }
}

extension MathHistoryQueryProperty
    on QueryBuilder<MathHistory, MathHistory, QQueryProperty> {
  QueryBuilder<MathHistory, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MathHistory, GeometrySceneEmbedded?, QQueryOperations>
      geometrySceneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'geometryScene');
    });
  }

  QueryBuilder<MathHistory, String, QQueryOperations> latexResultProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latexResult');
    });
  }

  QueryBuilder<MathHistory, String, QQueryOperations> ocrContentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ocrContent');
    });
  }

  QueryBuilder<MathHistory, String, QQueryOperations>
      originalImagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalImagePath');
    });
  }

  QueryBuilder<MathHistory, String, QQueryOperations>
      solutionMarkdownProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'solutionMarkdown');
    });
  }

  QueryBuilder<MathHistory, DateTime, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const GeometrySceneEmbeddedSchema = Schema(
  name: r'GeometrySceneEmbedded',
  id: 2002897275675453345,
  properties: {
    r'elements': PropertySchema(
      id: 0,
      name: r'elements',
      type: IsarType.objectList,
      target: r'GeometryElementEmbedded',
    ),
    r'viewport': PropertySchema(
      id: 1,
      name: r'viewport',
      type: IsarType.object,
      target: r'ViewportEmbedded',
    )
  },
  estimateSize: _geometrySceneEmbeddedEstimateSize,
  serialize: _geometrySceneEmbeddedSerialize,
  deserialize: _geometrySceneEmbeddedDeserialize,
  deserializeProp: _geometrySceneEmbeddedDeserializeProp,
);

int _geometrySceneEmbeddedEstimateSize(
  GeometrySceneEmbedded object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.elements.length * 3;
  {
    final offsets = allOffsets[GeometryElementEmbedded]!;
    for (var i = 0; i < object.elements.length; i++) {
      final value = object.elements[i];
      bytesCount += GeometryElementEmbeddedSchema.estimateSize(
          value, offsets, allOffsets);
    }
  }
  {
    final value = object.viewport;
    if (value != null) {
      bytesCount += 3 +
          ViewportEmbeddedSchema.estimateSize(
              value, allOffsets[ViewportEmbedded]!, allOffsets);
    }
  }
  return bytesCount;
}

void _geometrySceneEmbeddedSerialize(
  GeometrySceneEmbedded object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<GeometryElementEmbedded>(
    offsets[0],
    allOffsets,
    GeometryElementEmbeddedSchema.serialize,
    object.elements,
  );
  writer.writeObject<ViewportEmbedded>(
    offsets[1],
    allOffsets,
    ViewportEmbeddedSchema.serialize,
    object.viewport,
  );
}

GeometrySceneEmbedded _geometrySceneEmbeddedDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GeometrySceneEmbedded();
  object.elements = reader.readObjectList<GeometryElementEmbedded>(
        offsets[0],
        GeometryElementEmbeddedSchema.deserialize,
        allOffsets,
        GeometryElementEmbedded(),
      ) ??
      [];
  object.viewport = reader.readObjectOrNull<ViewportEmbedded>(
    offsets[1],
    ViewportEmbeddedSchema.deserialize,
    allOffsets,
  );
  return object;
}

P _geometrySceneEmbeddedDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<GeometryElementEmbedded>(
            offset,
            GeometryElementEmbeddedSchema.deserialize,
            allOffsets,
            GeometryElementEmbedded(),
          ) ??
          []) as P;
    case 1:
      return (reader.readObjectOrNull<ViewportEmbedded>(
        offset,
        ViewportEmbeddedSchema.deserialize,
        allOffsets,
      )) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension GeometrySceneEmbeddedQueryFilter on QueryBuilder<
    GeometrySceneEmbedded, GeometrySceneEmbedded, QFilterCondition> {
  QueryBuilder<GeometrySceneEmbedded, GeometrySceneEmbedded,
      QAfterFilterCondition> elementsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'elements',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<GeometrySceneEmbedded, GeometrySceneEmbedded,
      QAfterFilterCondition> elementsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'elements',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<GeometrySceneEmbedded, GeometrySceneEmbedded,
      QAfterFilterCondition> elementsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'elements',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GeometrySceneEmbedded, GeometrySceneEmbedded,
      QAfterFilterCondition> elementsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'elements',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<GeometrySceneEmbedded, GeometrySceneEmbedded,
      QAfterFilterCondition> elementsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'elements',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GeometrySceneEmbedded, GeometrySceneEmbedded,
      QAfterFilterCondition> elementsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'elements',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<GeometrySceneEmbedded, GeometrySceneEmbedded,
      QAfterFilterCondition> viewportIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'viewport',
      ));
    });
  }

  QueryBuilder<GeometrySceneEmbedded, GeometrySceneEmbedded,
      QAfterFilterCondition> viewportIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'viewport',
      ));
    });
  }
}

extension GeometrySceneEmbeddedQueryObject on QueryBuilder<
    GeometrySceneEmbedded, GeometrySceneEmbedded, QFilterCondition> {
  QueryBuilder<GeometrySceneEmbedded, GeometrySceneEmbedded,
          QAfterFilterCondition>
      elementsElement(FilterQuery<GeometryElementEmbedded> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'elements');
    });
  }

  QueryBuilder<GeometrySceneEmbedded, GeometrySceneEmbedded,
      QAfterFilterCondition> viewport(FilterQuery<ViewportEmbedded> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'viewport');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ViewportEmbeddedSchema = Schema(
  name: r'ViewportEmbedded',
  id: 7839582388643957408,
  properties: {
    r'xMax': PropertySchema(
      id: 0,
      name: r'xMax',
      type: IsarType.double,
    ),
    r'xMin': PropertySchema(
      id: 1,
      name: r'xMin',
      type: IsarType.double,
    ),
    r'yMax': PropertySchema(
      id: 2,
      name: r'yMax',
      type: IsarType.double,
    ),
    r'yMin': PropertySchema(
      id: 3,
      name: r'yMin',
      type: IsarType.double,
    )
  },
  estimateSize: _viewportEmbeddedEstimateSize,
  serialize: _viewportEmbeddedSerialize,
  deserialize: _viewportEmbeddedDeserialize,
  deserializeProp: _viewportEmbeddedDeserializeProp,
);

int _viewportEmbeddedEstimateSize(
  ViewportEmbedded object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _viewportEmbeddedSerialize(
  ViewportEmbedded object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.xMax);
  writer.writeDouble(offsets[1], object.xMin);
  writer.writeDouble(offsets[2], object.yMax);
  writer.writeDouble(offsets[3], object.yMin);
}

ViewportEmbedded _viewportEmbeddedDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ViewportEmbedded();
  object.xMax = reader.readDouble(offsets[0]);
  object.xMin = reader.readDouble(offsets[1]);
  object.yMax = reader.readDouble(offsets[2]);
  object.yMin = reader.readDouble(offsets[3]);
  return object;
}

P _viewportEmbeddedDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ViewportEmbeddedQueryFilter
    on QueryBuilder<ViewportEmbedded, ViewportEmbedded, QFilterCondition> {
  QueryBuilder<ViewportEmbedded, ViewportEmbedded, QAfterFilterCondition>
      xMaxEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'xMax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViewportEmbedded, ViewportEmbedded, QAfterFilterCondition>
      xMaxGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'xMax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViewportEmbedded, ViewportEmbedded, QAfterFilterCondition>
      xMaxLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'xMax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViewportEmbedded, ViewportEmbedded, QAfterFilterCondition>
      xMaxBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'xMax',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViewportEmbedded, ViewportEmbedded, QAfterFilterCondition>
      xMinEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'xMin',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViewportEmbedded, ViewportEmbedded, QAfterFilterCondition>
      xMinGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'xMin',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViewportEmbedded, ViewportEmbedded, QAfterFilterCondition>
      xMinLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'xMin',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViewportEmbedded, ViewportEmbedded, QAfterFilterCondition>
      xMinBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'xMin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViewportEmbedded, ViewportEmbedded, QAfterFilterCondition>
      yMaxEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yMax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViewportEmbedded, ViewportEmbedded, QAfterFilterCondition>
      yMaxGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'yMax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViewportEmbedded, ViewportEmbedded, QAfterFilterCondition>
      yMaxLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'yMax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViewportEmbedded, ViewportEmbedded, QAfterFilterCondition>
      yMaxBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'yMax',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViewportEmbedded, ViewportEmbedded, QAfterFilterCondition>
      yMinEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yMin',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViewportEmbedded, ViewportEmbedded, QAfterFilterCondition>
      yMinGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'yMin',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViewportEmbedded, ViewportEmbedded, QAfterFilterCondition>
      yMinLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'yMin',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViewportEmbedded, ViewportEmbedded, QAfterFilterCondition>
      yMinBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'yMin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension ViewportEmbeddedQueryObject
    on QueryBuilder<ViewportEmbedded, ViewportEmbedded, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const GeometryElementEmbeddedSchema = Schema(
  name: r'GeometryElementEmbedded',
  id: -5461284684695114228,
  properties: {
    r'centerX': PropertySchema(
      id: 0,
      name: r'centerX',
      type: IsarType.double,
    ),
    r'centerY': PropertySchema(
      id: 1,
      name: r'centerY',
      type: IsarType.double,
    ),
    r'constraint': PropertySchema(
      id: 2,
      name: r'constraint',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 3,
      name: r'id',
      type: IsarType.string,
    ),
    r'initialT': PropertySchema(
      id: 4,
      name: r'initialT',
      type: IsarType.double,
    ),
    r'label': PropertySchema(
      id: 5,
      name: r'label',
      type: IsarType.string,
    ),
    r'offsetX': PropertySchema(
      id: 6,
      name: r'offsetX',
      type: IsarType.double,
    ),
    r'offsetY': PropertySchema(
      id: 7,
      name: r'offsetY',
      type: IsarType.double,
    ),
    r'p1': PropertySchema(
      id: 8,
      name: r'p1',
      type: IsarType.string,
    ),
    r'p2': PropertySchema(
      id: 9,
      name: r'p2',
      type: IsarType.string,
    ),
    r'posX': PropertySchema(
      id: 10,
      name: r'posX',
      type: IsarType.double,
    ),
    r'posY': PropertySchema(
      id: 11,
      name: r'posY',
      type: IsarType.double,
    ),
    r'radius': PropertySchema(
      id: 12,
      name: r'radius',
      type: IsarType.double,
    ),
    r'style': PropertySchema(
      id: 13,
      name: r'style',
      type: IsarType.string,
    ),
    r'targetId': PropertySchema(
      id: 14,
      name: r'targetId',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 15,
      name: r'type',
      type: IsarType.string,
    ),
    r'visible': PropertySchema(
      id: 16,
      name: r'visible',
      type: IsarType.bool,
    )
  },
  estimateSize: _geometryElementEmbeddedEstimateSize,
  serialize: _geometryElementEmbeddedSerialize,
  deserialize: _geometryElementEmbeddedDeserialize,
  deserializeProp: _geometryElementEmbeddedDeserializeProp,
);

int _geometryElementEmbeddedEstimateSize(
  GeometryElementEmbedded object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.constraint.length * 3;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.label.length * 3;
  bytesCount += 3 + object.p1.length * 3;
  bytesCount += 3 + object.p2.length * 3;
  bytesCount += 3 + object.style.length * 3;
  bytesCount += 3 + object.targetId.length * 3;
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _geometryElementEmbeddedSerialize(
  GeometryElementEmbedded object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.centerX);
  writer.writeDouble(offsets[1], object.centerY);
  writer.writeString(offsets[2], object.constraint);
  writer.writeString(offsets[3], object.id);
  writer.writeDouble(offsets[4], object.initialT);
  writer.writeString(offsets[5], object.label);
  writer.writeDouble(offsets[6], object.offsetX);
  writer.writeDouble(offsets[7], object.offsetY);
  writer.writeString(offsets[8], object.p1);
  writer.writeString(offsets[9], object.p2);
  writer.writeDouble(offsets[10], object.posX);
  writer.writeDouble(offsets[11], object.posY);
  writer.writeDouble(offsets[12], object.radius);
  writer.writeString(offsets[13], object.style);
  writer.writeString(offsets[14], object.targetId);
  writer.writeString(offsets[15], object.type);
  writer.writeBool(offsets[16], object.visible);
}

GeometryElementEmbedded _geometryElementEmbeddedDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GeometryElementEmbedded();
  object.centerX = reader.readDouble(offsets[0]);
  object.centerY = reader.readDouble(offsets[1]);
  object.constraint = reader.readString(offsets[2]);
  object.id = reader.readString(offsets[3]);
  object.initialT = reader.readDouble(offsets[4]);
  object.label = reader.readString(offsets[5]);
  object.offsetX = reader.readDouble(offsets[6]);
  object.offsetY = reader.readDouble(offsets[7]);
  object.p1 = reader.readString(offsets[8]);
  object.p2 = reader.readString(offsets[9]);
  object.posX = reader.readDouble(offsets[10]);
  object.posY = reader.readDouble(offsets[11]);
  object.radius = reader.readDouble(offsets[12]);
  object.style = reader.readString(offsets[13]);
  object.targetId = reader.readString(offsets[14]);
  object.type = reader.readString(offsets[15]);
  object.visible = reader.readBool(offsets[16]);
  return object;
}

P _geometryElementEmbeddedDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension GeometryElementEmbeddedQueryFilter on QueryBuilder<
    GeometryElementEmbedded, GeometryElementEmbedded, QFilterCondition> {
  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> centerXEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'centerX',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> centerXGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'centerX',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> centerXLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'centerX',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> centerXBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'centerX',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> centerYEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'centerY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> centerYGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'centerY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> centerYLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'centerY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> centerYBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'centerY',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> constraintEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'constraint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> constraintGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'constraint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> constraintLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'constraint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> constraintBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'constraint',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> constraintStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'constraint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> constraintEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'constraint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
          QAfterFilterCondition>
      constraintContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'constraint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
          QAfterFilterCondition>
      constraintMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'constraint',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> constraintIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'constraint',
        value: '',
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> constraintIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'constraint',
        value: '',
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
          QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
          QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> initialTEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'initialT',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> initialTGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'initialT',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> initialTLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'initialT',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> initialTBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'initialT',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> labelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> labelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> labelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> labelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'label',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> labelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> labelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
          QAfterFilterCondition>
      labelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
          QAfterFilterCondition>
      labelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'label',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> labelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> labelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> offsetXEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'offsetX',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> offsetXGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'offsetX',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> offsetXLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'offsetX',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> offsetXBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'offsetX',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> offsetYEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'offsetY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> offsetYGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'offsetY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> offsetYLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'offsetY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> offsetYBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'offsetY',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> p1EqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'p1',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> p1GreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'p1',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> p1LessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'p1',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> p1Between(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'p1',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> p1StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'p1',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> p1EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'p1',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
          QAfterFilterCondition>
      p1Contains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'p1',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
          QAfterFilterCondition>
      p1Matches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'p1',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> p1IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'p1',
        value: '',
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> p1IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'p1',
        value: '',
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> p2EqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'p2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> p2GreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'p2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> p2LessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'p2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> p2Between(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'p2',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> p2StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'p2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> p2EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'p2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
          QAfterFilterCondition>
      p2Contains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'p2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
          QAfterFilterCondition>
      p2Matches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'p2',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> p2IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'p2',
        value: '',
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> p2IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'p2',
        value: '',
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> posXEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posX',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> posXGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'posX',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> posXLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'posX',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> posXBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'posX',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> posYEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> posYGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'posY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> posYLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'posY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> posYBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'posY',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> radiusEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'radius',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> radiusGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'radius',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> radiusLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'radius',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> radiusBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'radius',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> styleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'style',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> styleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'style',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> styleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'style',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> styleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'style',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> styleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'style',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> styleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'style',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
          QAfterFilterCondition>
      styleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'style',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
          QAfterFilterCondition>
      styleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'style',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> styleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'style',
        value: '',
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> styleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'style',
        value: '',
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> targetIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> targetIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> targetIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> targetIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> targetIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'targetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> targetIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'targetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
          QAfterFilterCondition>
      targetIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'targetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
          QAfterFilterCondition>
      targetIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'targetId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> targetIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetId',
        value: '',
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> targetIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'targetId',
        value: '',
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
          QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
          QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<GeometryElementEmbedded, GeometryElementEmbedded,
      QAfterFilterCondition> visibleEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'visible',
        value: value,
      ));
    });
  }
}

extension GeometryElementEmbeddedQueryObject on QueryBuilder<
    GeometryElementEmbedded, GeometryElementEmbedded, QFilterCondition> {}
