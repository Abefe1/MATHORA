#!/usr/bin/env python3
"""
Generates mathora_seed_topics_ss1_ss2_ss3.sql from a hand-curated
transcription of SYLLABUS/lagos_ss_syllabus_consolidated.md.

Why hand-curated instead of parsed from the .md automatically: the
source document mixes real content weeks ("Week 8: Trigonometric
Ratios...") with pure administrative weeks ("Week 7: Review of first
half term's work and periodic test.", "Revision.", "Examination.")
that have no lesson content to generate and would just pollute the
topics table. Telling those apart reliably needs judgment, not regex
(e.g. "Revision of angles on parallel lines cut by a transversal..."
IS real content despite starting with "Revision of" — it names
specific theorems; "Revision." alone is not). Every line below was
read against the source and classified by hand; SS3 Third Term is
correctly absent for both subjects — the source document states no
scheme of work exists for it (SS3 sits WAEC/NECO before that term).

description text is the source's original wording (title-cased lead
phrase only lightly reworded for a heading) — this is what Stage 2
generation will be grounded in, so it must stay faithful to the
source, not be summarized.

Run: python3 build_topics_seed.py
(writes ../mathora_seed_topics_ss1_ss2_ss3.sql directly, with explicit
UTF-8 encoding — do NOT pipe stdout to a file via shell redirection on
Windows, its console codepage mangles the em-dashes, curly quotes,
and degree signs (°, ½) used throughout the source text into mojibake)
"""

import sys
from pathlib import Path

# Fixed once, then reused on every re-run so the generated SQL is
# stable (re-running after a correction updates rows via ON CONFLICT
# rather than creating a duplicate curriculum).
MATH_CURRICULUM_ID = "b3f6b6a0-1c1a-4b8e-9c1e-000000000001"
FURTHER_MATH_CURRICULUM_ID = "b3f6b6a0-1c1a-4b8e-9c1e-000000000002"

# subject -> class_level (1/2/3 = SS1/SS2/SS3) -> term (1/2/3) -> [(title, description), ...]
DATA = {
    "Mathematics": {
        1: {
            1: [
                ("Revision of JSS3 Work & Operations on Integers", "Revision of JSS3 work and basic operations on integers — addition, subtraction, multiplication and division."),
                ("Number Bases", "Number Bases — (a) conversion from one base to base ten, (b) conversion of decimal fractions (\"bicimals\") in one base to base ten, (c) conversion of numbers from one base to another."),
                ("Number Bases: Arithmetic & Applications", "Number Bases (continued) — (a) addition, subtraction, multiplication and division of numbers in different bases, (b) application of number bases to computer programming."),
                ("Modular Arithmetic", "Concept of Modular Arithmetic — addition, subtraction, multiplication and division operations in modular arithmetic."),
                ("Standard Form and Approximation", "Standard Form and Approximation."),
                ("Indices", "Indices — (a) application of laws of indices, (b) negative, zero and fractional indices."),
                ("Logarithms of Numbers Greater Than 1", "Logarithms of numbers greater than 1 (whole numbers) — use of logarithm tables for multiplication and division of numbers."),
                ("Logarithms: Powers, Roots & Relationship to Indices", "Logarithms (continued) — (a) calculations involving powers and roots, (b) relationship between indices and logarithms."),
                ("Simple Equations, Variation & Change of Subject", "(a) Simple equations and variation, (b) change of subject of formulae, (c) types of variation — direct, inverse, joint and partial, (d) application of variation to practical problems."),
            ],
            2: [
                ("Quadratic Equations: Factorisation & Completing the Square", "Quadratic Equations by (a) factorisation, (b) completing the square method."),
                ("Quadratic Formula", "General form of a quadratic equation leading to the formula method, from ax² + bx + c = 0."),
                ("Quadratic Equations: Graphical Method", "Solving quadratic equations by graphical methods — reading the roots from the graph; determination of minimum and maximum values; line of symmetry."),
                ("Idea of Sets", "Idea of Sets — universal sets, finite and infinite sets, empty set, subsets."),
                ("Set Notation: Union, Intersection & Complement", "Notation for union and intersection of sets; complements of sets; disjoint/null sets."),
                ("Venn Diagrams", "Venn diagrams and their use in solving problems involving two and three sets, in relation to real-life situations."),
                ("Trigonometric Ratios", "Trigonometric Ratios — sine, cosine, tangent of acute angles; use of tables of trigonometric ratios; determination of length of chord using trigonometric ratios."),
                ("Sine & Cosine Graphs; Trig Applications", "Graph of sine and cosine for angles 0°–360°; (a) application of sine, cosine and tangent to simple problems on right-angled triangles, (b) angles of elevation and depression, (c) bearing and distances of places (strict application of trigonometric ratios)."),
                ("Circles: Introduction, Arc Length, Sectors & Segments", "(a) Introduction to circles and their properties, (b) calculation of length of arc and perimeter of a sector, (c) area of sectors and segments; area of triangles."),
                ("Logic: Statements & Implication", "Logic — simple true and false statements; negation and contrapositive of a simple statement; antecedent, consequent and conditional statements (implication)."),
            ],
            3: [
                ("Mensuration: 3-D Shapes, Surface Area & Volume", "Mensuration — the concept of 3-D shapes: cube, cuboid, cylinder, triangular prism, cone, rectangular-based pyramid; total surface area of cone and cylinder and their volumes."),
                ("Frustums & Angle Sum of a Triangle", "(a) Volumes of frustums of cones, rectangular-based pyramids and other pyramids, (b) proof that the angle sum of a triangle = 180°, (c) the exterior angle of a triangle."),
                ("Geometrical Construction: Triangles & Line Segments", "Geometrical Construction — revision of construction of triangles; drawing and bisection of a line segment; construction and bisection of angles 90°, 45°, 135°, 22½°, 57½°."),
                ("Construction & Bisection of Angles", "Construction and bisection of angles: 30°, 60°, 90°, 120°, 150°, etc."),
                ("Construction of Quadrilaterals & Equilateral Triangles", "Construction of a quadrilateral polygon (a four-sided figure with given conditions, e.g. a parallelogram); construction of an equilateral triangle."),
                ("Locus of Moving Points", "Locus of moving points, including equidistance from two lines/two points, and constant distance from a point."),
                ("Deductive Proof: Angle Sum of a Triangle", "Deductive proof: sum of angles of a triangle; relationship of triangles on a straight line."),
                ("Parallel Lines, Congruent Triangles & Parallelograms", "Revision of angles on parallel lines cut by a transversal; congruent triangles; properties of a parallelogram and the intercept theorem."),
                ("Statistics: Data Collection & Presentation", "Statistics — collection, tabulation and presentation of data (e.g. heights, ages, weights, test/exam scores, school/class populations, animal species, vehicle types, etc.)."),
                ("Range, Median & Mode (Ungrouped Data)", "Calculation of range, median and mode of ungrouped data (using data collected by students or from other statistical records)."),
                ("Grouped Data: Collection, Tabulation & Presentation", "Revision of collection, tabulation and presentation of grouped data (heights, ages, weights, test/exam scores, class populations)."),
                ("Range, Median & Mode (Grouped Data)", "Calculation of range, median and mode of grouped data."),
                ("Statistical Graphs", "Statistical graphs — drawing of bar chart, pie chart and histogram; cumulative frequency curve; reading and drawing inferences from graphs."),
                ("Mean Deviation, Variance & Standard Deviation", "Mean deviation, variance and standard deviation of grouped data, applied to practical/real-life problems."),
            ],
        },
        2: {
            1: [
                ("Logarithms: Numbers Less Than One & Reciprocals", "Revision of logarithm of numbers greater than one and logarithm of numbers less than one; reciprocals and accuracy of results using standard calculation."),
                ("Approximations, Standard Form & Percentage Error", "Approximations; calculations using standard form; significant figures; percentage error."),
                ("Sequences & Series: Arithmetic Progression", "Sequence and Series — concept of sequence and series; terms of Arithmetic Progressions (A.P.) and their sum; solving problems on A.P."),
                ("Geometric Progression", "Geometric Progressions — the nth term and sum of the first n terms; problem solving on G.P. and geometric mean."),
                ("Quadratic Equations from Sum & Product of Roots", "Construction of a quadratic equation from the sum and product of roots; word problems leading to quadratic equations."),
                ("Simultaneous Equations: Elimination & Substitution", "Simultaneous Equations — solving by elimination and substitution methods; word problems leading to simultaneous equations."),
                ("Simultaneous Equations: Linear & Quadratic", "Simultaneous Equations — solving equations involving one linear and one quadratic equation; using graphical methods to solve quadratic equations."),
                ("Straight Line Graphs: Gradient", "Straight Line Graphs — gradient of a straight line; gradient of a curve; drawing tangents to a curve."),
            ],
            2: [
                ("Gradient of a Straight Line & a Curve", "Revision — Straight lines: gradient of a straight line, gradient of a curve, drawing of tangents to a curve."),
                ("Inequalities in One and Two Variables", "Inequalities — (a) revision of linear inequalities in one variable, (b) solutions of inequalities in two variables, (c) range of values of combined inequalities."),
                ("Graphs of Linear Inequalities", "Graphs of linear inequalities in two variables; maximum and minimum values of simultaneous linear inequalities."),
                ("Linear Inequalities: Applications & Linear Programming", "Application of linear inequalities to real life; introduction to linear programming."),
                ("Algebraic Fractions", "Algebraic Fractions — simplification of fractions; operations on algebraic fractions."),
                ("Equations Involving Fractions", "Equations involving fractions; undefined fractions (e.g. y is undefined when the denominator ax + c = 0)."),
                ("Fractions: Substitution & Simultaneous Equations", "Fractions (continued) — substitution in fractions; simultaneous equations involving fractions."),
                ("Logic: Compound Statements & Truth Tables", "Logic — simple and compound statements; logical operations and truth tables; conditional statements and indirect proofs."),
                ("Chord Properties of Circles", "Chord properties of circles — perpendicular bisector of a chord; distance of equal chords from the centre of a circle; angles subtended by two equal chords."),
                ("Circle Theorems: Angle Properties", "Circle Theorems — angle properties of a circle; angle subtended by an arc at the centre is twice that subtended at the circumference; angles in the same segment; angles in a semicircle; opposite angles of a cyclic quadrilateral."),
            ],
            3: [
                ("Circle Theorems: Tangent Properties", "Circle Theorems — tangent properties of a circle; angles in the alternate segment; two tangents from an external point."),
                ("Sine Rule & Cosine Rule", "Trigonometry — derivation of the sine rule and cosine rule and their applications."),
                ("Bearing, Distances, Elevation & Depression", "Bearing and Distances; Elevation and Depression."),
                ("Statistics: Class Boundaries & Cumulative Frequency", "Statistics — class boundaries, class marks, and cumulative frequencies of grouped data; histograms."),
                ("Cumulative Frequency Curve (Ogive)", "Statistics — cumulative frequency curve (Ogive); using the ogive to calculate the median, quartile, percentile and decile."),
                ("Mean, Median & Mode of Grouped Data", "Statistics — mean, median and mode of grouped data."),
                ("Probability: Introduction", "Probability — introduction; use of dice, coins and playing cards."),
                ("Probability: Addition & Multiplication Rules", "Probability — addition and multiplication rules; mutually exclusive, independent and complementary events; experiments with or without replacement."),
            ],
        },
        3: {
            1: [
                ("Revision: Indices and Logarithm", "Revision: Indices and Logarithm."),
                ("Surds", "Surds."),
                ("Surds in Relation to Trigonometry", "Surds in relation to Trigonometry."),
                ("Matrices and Determinants", "Matrices and Determinants."),
                ("Linear and Quadratic Equations", "Linear and Quadratic Equations."),
                ("Surface Area & Volume of Sphere and Hemispherical Shapes", "Surface Area and Volume of Sphere and Hemispherical Shapes."),
                ("Longitude and Latitude", "Longitude and Latitude."),
                ("Longitude and Latitude (Continued)", "Longitude and Latitude (continued)."),
                ("Arithmetic of Finance", "Arithmetic of Finance."),
            ],
            2: [
                ("Interest on Bonds & Debentures; Taxes and VAT", "Calculation of interest on bonds and debentures using logarithm tables; problems on taxes and value-added tax (VAT)."),
                ("Coordinate Geometry: Distance & Midpoint", "Coordinate Geometry of straight lines — Cartesian coordinate graphs; distance between two points; midpoint of the line joining two points."),
                ("Coordinate Geometry: Gradient, Intercepts & Angle Between Lines", "Coordinate Geometry of straight lines — gradient and intercepts of a line; angle between two intersecting straight lines and applications."),
                ("Differentiation: First Principles & Standard Derivatives", "Differentiation of algebraic functions — meaning of differentiation; differentiation from first principles; standard derivatives of basic functions."),
                ("Differentiation: Rules, Maxima & Minima", "Differentiation of algebraic functions — basic rules of differentiation (sum and difference, product rule, quotient rule); maxima and minima applications."),
                ("Integration of Algebraic Functions", "Integration and evaluation of simple algebraic functions — definition; methods of integration (substitution, partial fractions, integration by parts); area under a curve; use of Simpson's rule."),
            ],
        },
    },
    "Further Mathematics": {
        1: {
            1: [
                ("Indices: Basic Laws & Application", "Indices — Basic Laws & Application of Indices."),
                ("Indicial and Exponential Equations", "Indicial and Exponential Equations."),
                ("Logarithms: Laws and Application", "Logarithms — Laws and Application."),
                ("Set Theory: General Review", "General review of basic concept of set theory."),
                ("Operations on Sets & Venn Diagrams", "Operation of sets and Venn diagrams."),
                ("Binary Operations: Definitions & Basic Laws", "Binary Operations and basic laws of binary operations — (i) definition, (ii) solution of simple problems on binary operations, (iii) closure, commutative, associative and distributive laws."),
                ("Binary Operations: Identity, Inverse & Tables", "Binary Operations (continued) — (i) solution to problems on laws of binary operations, (ii) identity and inverse elements of a given binary operation, (iii) addition and multiplication tables for binary operations."),
                ("Surds: Definition, Rules & Rationalization", "Surds — (i) definition of surds, (ii) rules and manipulation of surds, (iii) rationalization of surds at the denominator and equality of surds."),
                ("Measures of Central Tendency", "Measures of Central Tendency — (i) mean, median and mode of grouped and ungrouped data, (ii) estimation of mode from the histogram of a grouped data."),
            ],
            2: [
                ("Arithmetic Progression (A.P.)", "Arithmetic Progression (A.P.)."),
                ("Geometric Progression (G.P.)", "Geometric Progression (G.P.)."),
                ("Linear Inequalities in One Variable", "Linear inequalities in one variable."),
                ("Inequalities in Two Variables", "Inequalities in two variables (graph of inequalities)."),
                ("Introduction to Functions", "Introduction to the concept of functions."),
                ("Functions: One-to-One, Onto, Composite & Inverse", "Functions — one-to-one, onto, composite and inverse functions."),
                ("Trigonometric Ratios: Graphs & Special Angles", "Trigonometric ratios — graphs of sine, cosine and tangent of angles; derivation of trigonometric ratios of special angles (30°, 45° and 60°); application of trigonometric ratios."),
                ("Logical Reasoning: Negation, Converse & Contrapositive", "Logical reasoning — simple true and false statements; negation, converse and contrapositive of a statement."),
                ("Logical Reasoning: Compound Statements & Connectives", "Logical reasoning (continued) — compound statements, connectives and their symbols; conditional statements and symbols."),
            ],
            3: [
                ("Flowcharts", "Flowcharts — diagrammatic representation of a solution to a problem; advantages of flowcharts."),
                ("Gradients of Straight Lines and Curves", "Gradients of straight lines and curves — gradient of a straight line."),
                ("Straight Lines: Angle of Slope & Angle Between Lines", "Straight lines — angle of slope and angle between lines."),
                ("Vectors: Modulus", "Vectors — modulus of a vector."),
                ("Vectors: Magnitude, Zero, Unit & Negative Vectors", "Vectors (continued) — magnitude of a vector, zero vector, unit vector, negative vector, equality of vectors."),
                ("Straight Lines: Gradient-Intercept & Two-Point Form", "Straight lines — angle between lines; gradient-intercept form; equation of a straight line (gradient and one-point form, two-point form)."),
            ],
        },
        2: {
            1: [
                ("Quadratic Equations: Sum & Product of Roots", "Solution to Quadratic Equations — finding a quadratic equation given the sum and product of roots; conditions for equal roots, real roots and no roots."),
                ("Tangents and Normals to Curves", "Tangents and Normals to Curves."),
                ("Polynomials", "Polynomials."),
                ("Polynomials (Continued)", "Polynomials (continued)."),
                ("Cubic Equations", "Cubic Equations — cubic equations and their factorization; graphs of cubic equations."),
                ("Logical Reasoning: Statements & Truth Values", "Logical Reasoning — statements, truth values, negation, converse and contrapositive."),
                ("Trigonometric Functions", "Trigonometric Functions."),
                ("Graphs of Trigonometric Functions", "Graphs of Trigonometric Functions."),
                ("Trigonometric Identities & Inverse Trig Ratios", "Trigonometric Identities and graphs of inverse trigonometric ratios."),
            ],
            2: [
                ("Differentiation: Limits & First Principles", "Differentiation — limits of functions and differentiation from first principles; differentiation of polynomials."),
                ("Rules of Differentiation", "Differentiation (continued) — rules of differentiation."),
                ("Differentiation of Transcendental Functions", "Differentiation of transcendental functions — derivatives of trigonometric and exponential functions."),
                ("Applications of Differentiation", "Application of Differentiation — rate of change, equations of motion, maximum and minimum points and values of functions."),
                ("Conic Sections: Circles", "Conic Sections — equation of circles, general equation of circles, finding centre and radius, equation and length of tangents to a circle."),
                ("Conic Sections: Parabola, Hyperbola & Ellipse", "Conic Sections (continued) — the parabola, hyperbola and ellipse."),
                ("Probability: Sample Space & Events", "Statistics/Probability — sample space, event space, combination of events, independent and dependent events."),
                ("Permutation and Combination", "Permutation and Combination."),
                ("Dynamics: Newton's Laws of Motion", "Dynamics — Newton's Laws of Motion."),
                ("Work, Energy, Power, Impulse and Momentum", "Work, Energy, Power, Impulse and Momentum."),
            ],
            3: [
                ("Projectiles", "Projectiles — trajectory of a projectile, greatest height reached, time of flight, range, and projectile motion along an inclined plane."),
                ("Binomial Expansion", "Binomial Expansion — Pascal's triangle; binomial theorem for negative, positive and fractional powers."),
                ("Mechanics: Vectors in Two and Three Dimensions", "Mechanics — vectors in two and three dimensions; scalar product of vectors in three dimensions."),
                ("Vector (Cross) Product in Three Dimensions", "Vector (cross) product in three dimensions; application of the cross product of two vectors."),
                ("Integration: Indefinite Integrals", "Integration — concept of indefinite integrals; methods of integration (e.g. algebraic and trigonometric substitution, by parts, and partial fractions)."),
                ("Integration: Definite Integrals & Area Under a Curve", "Integration (continued) — definite integrals; area under a curve."),
                ("Integration: Kinematics, Volumes & Trapezium Rule", "Integration (continued) — application of integration to kinematics, volumes of solids of revolution, and the trapezium rule."),
                ("Correlation and Regression", "Correlation and Regression — concept, scatter diagram, regression line, coefficient of regression, rank correlation and product-moment correlation coefficient."),
            ],
        },
        3: {
            1: [
                ("Probability Distribution: Binomial & Poisson", "Probability Distribution — Binomial Probability Distribution; Poisson Probability Distribution."),
                ("Probability Distribution: Normal Distribution", "Probability Distribution (continued) — Normal Distribution; properties and area; z-scores and application."),
                ("Statics: Resultant of Forces", "Statics — definition of concepts; resultant of two forces; components/resolution of forces."),
                ("Statics: Equilibrium & Lami's Theorem", "Statics (continued) — definition of equilibrium and condition of equilibrium of a rigid body; application of the condition to solve problems; Lami's Theorem and application."),
                ("Statics: Moment of a Force", "Statics (continued) — definition of moment of a force; principles of moments; application of the principle in solving problems."),
                ("Friction", "Friction — basic concept; coefficient of friction; forces acting on a body."),
            ],
            2: [
                ("Statics: Moment of Force (Two & Three Forces)", "Statics — moment of force (two and three forces) acting at a point."),
                ("Statics: Polygon of Forces & Resolution of Friction", "Statics — (i) polygon of forces, (ii) resolution of forces of friction."),
                ("Modelling: Introduction", "Modelling — (i) introduction to modelling, (ii) dependent and independent variables in mathematical modelling, (iii) examples of some models."),
                ("Modelling: Construction & Methodology", "Modelling (continued) — (i) construction of a model, (ii) methodology of modelling, (iii) application to physical, biological, social and behavioural sciences."),
                ("Games Theory: Introduction", "Games Theory — (i) introduction to games theory, (ii) description of types of games."),
                ("Games Theory: Minimax Strategies & Matrix Games", "Games Theory (continued) — (i) solution of two-person zero-sum games using pure and minimax strategies, (ii)/(iii) matrix games."),
            ],
        },
    },
}


def esc(s: str) -> str:
    return s.replace("'", "''")


def main():
    out = []
    out.append("-- ==========================================")
    out.append("-- MATHORA — SS1-SS3 Topics Seed (Mathematics & Further Mathematics)")
    out.append("-- Auto-generated by SYLLABUS/build_topics_seed.py from a hand-curated")
    out.append("-- transcription of SYLLABUS/lagos_ss_syllabus_consolidated.md.")
    out.append("-- Run after mathora_schema.sql + mathora_schema_topics_term_patch.sql.")
    out.append("-- Safe to re-run: uses ON CONFLICT on the (curriculum_id, class_level,")
    out.append("-- term, order_index) unique index to update in place.")
    out.append("-- ==========================================\n")

    out.append("insert into public.curricula (id, title, subject, description) values")
    out.append(f"  ('{MATH_CURRICULUM_ID}', 'Nigerian National Curriculum (NERDC) — WAEC SSCE Aligned', 'Mathematics', 'SS1-SS3 core Mathematics, sourced from the Lagos State Ministry of Education scheme of work.'),")
    out.append(f"  ('{FURTHER_MATH_CURRICULUM_ID}', 'Nigerian National Curriculum (NERDC) — WAEC SSCE Aligned', 'Further Mathematics', 'SS1-SS3 Further Mathematics, sourced from the Lagos State Ministry of Education scheme of work.')")
    out.append("on conflict (id) do update set title = excluded.title, description = excluded.description;\n")

    out.append("insert into public.topics (curriculum_id, class_level, term, title, description, order_index) values")

    rows = []
    for subject, classes in DATA.items():
        curriculum_id = MATH_CURRICULUM_ID if subject == "Mathematics" else FURTHER_MATH_CURRICULUM_ID
        for class_num, terms in classes.items():
            class_level = f"SS{class_num}"
            for term_num, topics in terms.items():
                for i, (title, description) in enumerate(topics, start=1):
                    order_index = term_num * 100 + i
                    rows.append(
                        f"  ('{curriculum_id}', '{class_level}', {term_num}, '{esc(title)}', '{esc(description)}', {order_index})"
                    )

    out.append(",\n".join(rows))
    out.append("on conflict (curriculum_id, class_level, term, order_index) do update set")
    out.append("  title = excluded.title, description = excluded.description;")

    dest = Path(__file__).resolve().parent.parent / "mathora_seed_topics_ss1_ss2_ss3.sql"
    dest.write_text("\n".join(out) + "\n", encoding="utf-8")

    print(f"Wrote {len(rows)} topics to {dest}", file=sys.stderr)


if __name__ == "__main__":
    main()
