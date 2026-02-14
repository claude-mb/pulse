import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

/// Defines a player shape with vertices that fit within a 40x40 bounding box.
///
/// Each shape has an [id] for persistence, a display [name], an [xpCost]
/// threshold for unlocking, and [vertices] that define the polygon path
/// used for both rendering and the [PolygonComponent] constructor.
class PlayerShape {
  const PlayerShape({
    required this.id,
    required this.name,
    required this.xpCost,
    required this.vertices,
  });

  /// Unique identifier used for persistence (e.g. 'diamond', 'star').
  final String id;

  /// Human-readable display name (e.g. 'Diamond', 'Star').
  final String name;

  /// XP threshold required to unlock this shape. 0 = default/free.
  final int xpCost;

  /// Polygon vertices fitting within a 40x40 bounding box.
  ///
  /// Used directly by [PolygonComponent] and by the [path] getter for
  /// custom canvas rendering (glow layer, etc.).
  final List<Vector2> vertices;

  /// Builds a [Path] from [vertices] for canvas drawing operations.
  Path get path {
    final p = Path();
    p.moveTo(vertices.first.x, vertices.first.y);
    for (var i = 1; i < vertices.length; i++) {
      p.lineTo(vertices[i].x, vertices[i].y);
    }
    p.close();
    return p;
  }

  /// The centroid of all vertices — used as the scaling origin for the
  /// glow/pulse effect.
  Vector2 get center {
    double cx = 0;
    double cy = 0;
    for (final v in vertices) {
      cx += v.x;
      cy += v.y;
    }
    return Vector2(cx / vertices.length, cy / vertices.length);
  }
}

/// All available player shapes.
///
/// Shapes are defined as static instances with pre-computed vertices
/// fitting within a 40x40 bounding box. Use [getById] to look up a
/// shape by its persistence identifier.
class PlayerShapes {
  PlayerShapes._();

  /// Default shape — the classic diamond/rhombus.
  static final diamond = PlayerShape(
    id: 'diamond',
    name: 'Diamond',
    xpCost: 0,
    vertices: [
      Vector2(20, 0),
      Vector2(40, 20),
      Vector2(20, 40),
      Vector2(0, 20),
    ],
  );

  /// Approximate circle as an 8-vertex polygon.
  static final circle = PlayerShape(
    id: 'circle',
    name: 'Circle',
    xpCost: 500,
    vertices: [
      Vector2(20, 0),
      Vector2(34, 6),
      Vector2(40, 20),
      Vector2(34, 34),
      Vector2(20, 40),
      Vector2(6, 34),
      Vector2(0, 20),
      Vector2(6, 6),
    ],
  );

  /// Equilateral-ish triangle pointing upward.
  static final triangle = PlayerShape(
    id: 'triangle',
    name: 'Triangle',
    xpCost: 1500,
    vertices: [
      Vector2(20, 2),
      Vector2(38, 36),
      Vector2(2, 36),
    ],
  );

  /// Regular hexagon.
  static final hexagon = PlayerShape(
    id: 'hexagon',
    name: 'Hexagon',
    xpCost: 3000,
    vertices: [
      Vector2(20, 0),
      Vector2(38, 10),
      Vector2(38, 30),
      Vector2(20, 40),
      Vector2(2, 30),
      Vector2(2, 10),
    ],
  );

  /// 5-point star with alternating outer and inner vertices.
  static final star = PlayerShape(
    id: 'star',
    name: 'Star',
    xpCost: 5000,
    vertices: _buildStarVertices(),
  );

  /// All available shapes ordered by XP cost.
  static final List<PlayerShape> all = [
    diamond,
    circle,
    triangle,
    hexagon,
    star,
  ];

  /// Returns the shape matching [id], or [diamond] as a fallback.
  static PlayerShape getById(String id) {
    return all.firstWhere(
      (s) => s.id == id,
      orElse: () => diamond,
    );
  }

  /// Generates a 5-point star's 10 vertices (alternating outer/inner)
  /// centered at (20, 20) with outer radius 20 and inner radius 9.
  static List<Vector2> _buildStarVertices() {
    final vertices = <Vector2>[];
    const cx = 20.0;
    const cy = 20.0;
    const outerR = 20.0;
    const innerR = 9.0;
    const points = 5;

    for (var i = 0; i < points * 2; i++) {
      // Start from top (-pi/2) and alternate outer/inner.
      final angle = -math.pi / 2 + i * math.pi / points;
      final r = i.isEven ? outerR : innerR;
      vertices.add(Vector2(
        cx + r * math.cos(angle),
        cy + r * math.sin(angle),
      ));
    }
    return vertices;
  }
}
