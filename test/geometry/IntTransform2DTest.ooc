/* This file is part of magic-sdk, an sdk for the open source programming language magic.
 *
 * Copyright (C) 2016 magic-lang
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 */

use unit
use geometry

IntTransform2DTest: class extends Fixture {
	transform0 := IntTransform2D new(3, 1, 2, 1, 5, 7)
	transform1 := IntTransform2D new(7, 4, 2, 5, 7, 6)
	transform2 := IntTransform2D new(29, 11, 16, 7, 38, 20)
	transform3 := IntTransform2D new(1, -1, -2, 3, 9, -16)
	transform4 := IntTransform2D new(10, 20, 30, 40, 50, 60)
	point0 := IntPoint2D new(-7, 3)
	point1 := IntPoint2D new(-10, 3)
	size := IntVector2D new(10, 10)
	init: func {
		super("IntTransform2D")
		this add("fixture", func {
			expect(this transform0 * this transform1, is equal to(this transform2))
		})
		this add("equality", func {
			transform := IntTransform2D new()
			expect(this transform0 == this transform0, is true)
			expect(this transform0 == this transform1, is false)
			expect(this transform0 == transform, is false)
			expect(transform == transform, is true)
			expect(transform == this transform0, is false)
		})
		this add("inverse transform", func {
			expect(this transform0 inverse == this transform3, is true)
		})
		this add("multiplication, transform - transform", func {
			expect(this transform0 * this transform1 == this transform2, is true)
		})
		this add("multiplication, transform - point", func {
			expect(this transform0 * this point0 == this point1, is true)
		})
		this add("create zero transform", func {
			transform := IntTransform2D new()
			expect(transform a, is equal to(0))
			expect(transform b, is equal to(0))
			expect(transform c, is equal to(0))
			expect(transform d, is equal to(0))
			expect(transform e, is equal to(0))
			expect(transform f, is equal to(0))
			expect(transform g, is equal to(0))
			expect(transform h, is equal to(0))
			expect(transform i, is equal to(0))
		})
		this add("create identity transform", func {
			transform := IntTransform2D identity
			expect(transform a, is equal to(1))
			expect(transform b, is equal to(0))
			expect(transform c, is equal to(0))
			expect(transform d, is equal to(0))
			expect(transform e, is equal to(1))
			expect(transform f, is equal to(0))
			expect(transform g, is equal to(0))
			expect(transform h, is equal to(0))
			expect(transform i, is equal to(1))
		})
		this add("rotate", func {
			angle := Float pi
			transform := IntTransform2D createZRotation(angle)
			transform = transform rotate(-angle)
			expect(transform a, is equal to(1))
			expect(transform b, is equal to(0))
			expect(transform c, is equal to(0))
			expect(transform d, is equal to(0))
			expect(transform e, is equal to(1))
			expect(transform f, is equal to(0))
			expect(transform g, is equal to(0))
			expect(transform h, is equal to(0))
			expect(transform i, is equal to(1))
		})
		this add("scale", func {
			scale := 20
			transform := IntTransform2D createScaling(scale, scale)
			transform = transform scale(5)
			expect(transform a, is equal to(100))
			expect(transform b, is equal to(0))
			expect(transform c, is equal to(0))
			expect(transform d, is equal to(0))
			expect(transform e, is equal to(100))
			expect(transform f, is equal to(0))
			expect(transform g, is equal to(0))
			expect(transform h, is equal to(0))
			expect(transform i, is equal to(1))
		})
		this add("translate", func {
			xDelta := 40
			yDelta := -40
			transform := IntTransform2D createTranslation(xDelta, yDelta)
			transform = transform translate(-xDelta, -yDelta)
			expect(transform a, is equal to(1))
			expect(transform b, is equal to(0))
			expect(transform c, is equal to(0))
			expect(transform d, is equal to(0))
			expect(transform e, is equal to(1))
			expect(transform f, is equal to(0))
			expect(transform g, is equal to(0))
			expect(transform h, is equal to(0))
			expect(transform i, is equal to(1))
		})
		this add("create rotation", func {
			angle := Float pi
			transform := IntTransform2D createZRotation(angle)
			expect(transform a, is equal to(-1))
			expect(transform b, is equal to(0))
			expect(transform d, is equal to(0))
			expect(transform e, is equal to(-1))
			expect(transform g, is equal to(0))
			expect(transform h, is equal to(0))
		})
		this add("create scale", func {
			scale := 20
			transform := IntTransform2D createScaling(scale, scale)
			expect(transform a, is equal to(scale))
			expect(transform b, is equal to(0))
			expect(transform d, is equal to(0))
			expect(transform e, is equal to(scale))
			expect(transform g, is equal to(0))
			expect(transform h, is equal to(0))
		})
		this add("create translation", func {
			xDelta := 40
			yDelta := -40
			transform := IntTransform2D createTranslation(xDelta, yDelta)
			expect(transform a, is equal to(1))
			expect(transform b, is equal to(0))
			expect(transform d, is equal to(0))
			expect(transform e, is equal to(1))
			expect(transform g, is equal to(xDelta))
			expect(transform h, is equal to(yDelta))
		})
		this add("get values", func {
			transform := this transform0
			expect(transform a, is equal to(3))
			expect(transform b, is equal to(1))
			expect(transform c, is equal to(0))
			expect(transform d, is equal to(2))
			expect(transform e, is equal to(1))
			expect(transform f, is equal to(0))
			expect(transform g, is equal to(5))
			expect(transform h, is equal to(7))
			expect(transform i, is equal to(1))
		})
		this add("toText", func {
			text := IntTransform2D new(3.0, 1.0, 2.0, 1.0, 5.0, 7.0) toText() take()
			expect(text, is equal to(t"3, 1, 0\t2, 1, 0\t5, 7, 1"))
			text free()
		})
		this add("toString", func {
			string := IntTransform2D new(3, 1, 0, -11, 0, 2) toString()
			expect(string, is equal to("3, 1, 0\t0, -11, 0\t0, 2, 1\t"))
			string free()
		})
		this add("toFloatTransform2D", func {
			transform := this transform0 toFloatTransform2D()
			expect(transform a, is equal to(3.f) within(0.0001f))
			expect(transform b, is equal to(1.f) within(0.0001f))
			expect(transform c, is equal to(0.f) within(0.0001f))
			expect(transform d, is equal to(2.f) within(0.0001f))
			expect(transform e, is equal to(1.f) within(0.0001f))
			expect(transform f, is equal to(0.f) within(0.0001f))
			expect(transform g, is equal to(5.f) within(0.0001f))
			expect(transform h, is equal to(7.f) within(0.0001f))
			expect(transform i, is equal to(1.f) within(0.0001f))
		})
		this add ("isProjective", func {
			expect(this transform0 isProjective, is true)
			expect(this transform1 isProjective, is true)
			expect(this transform2 isProjective, is true)
			expect(this transform3 isProjective, is equal to(this transform2 isProjective))
			expect(this transform4 isProjective, is true)
		})
		this add ("isAffine", func {
			expect(this transform0 isAffine, is true)
			expect(this transform1 isAffine, is true)
			expect(this transform2 isAffine, is true)
			expect(this transform3 isAffine, is true)
			expect(this transform4 isAffine, is true)
		})
		this add("isIdentity", func {
			expect(this transform0 isIdentity, is false)
			expect(this transform3 isIdentity, is false)
		})
		this add("createReflectionX", func {
			reflectX := IntTransform2D createReflectionX()
			expect(reflectX a, is equal to(-1))
			expect(reflectX b, is equal to(0))
			expect(reflectX c, is equal to(0))
			expect(reflectX d, is equal to(0))
			expect(reflectX e, is equal to(1))
			expect(reflectX f, is equal to(0))
			expect(reflectX g, is equal to(0))
			expect(reflectX h, is equal to(0))
			expect(reflectX i, is equal to(1))
		})
		this add("createReflectionY", func {
			reflectY := IntTransform2D createReflectionY()
			expect(reflectY a, is equal to(1))
			expect(reflectY b, is equal to(0))
			expect(reflectY c, is equal to(0))
			expect(reflectY d, is equal to(0))
			expect(reflectY e, is equal to(-1))
			expect(reflectY f, is equal to(0))
			expect(reflectY g, is equal to(0))
			expect(reflectY h, is equal to(0))
			expect(reflectY i, is equal to(1))
		})
		this add("setTranslation", func {
			transform := this transform0 setTranslation(IntVector2D new(-7, 3))
			expect(transform a, is equal to(3))
			expect(transform b, is equal to(1))
			expect(transform c, is equal to(0))
			expect(transform d, is equal to(2))
			expect(transform e, is equal to(1))
			expect(transform f, is equal to(0))
			expect(transform g, is equal to(-7))
			expect(transform h, is equal to(3))
			expect(transform i, is equal to(1))
		})
		this add("skewX", func {
			transform := this transform0 skewX(Float pi / 6.f)
			expect(transform a, is equal to(3))
			expect(transform b, is equal to(1))
			expect(transform c, is equal to(0))
			expect(transform d, is equal to(2))
			expect(transform e, is equal to(1))
			expect(transform f, is equal to(0))
			expect(transform g, is equal to(5))
			expect(transform h, is equal to(7))
			expect(transform i, is equal to(1))
		})
		this add("skewY", func {
			transform := this transform0 skewY(Float pi / 6.f)
			expect(transform a, is equal to(3))
			expect(transform b, is equal to(1))
			expect(transform c, is equal to(0))
			expect(transform d, is equal to(2))
			expect(transform e, is equal to(1))
			expect(transform f, is equal to(0))
			expect(transform g, is equal to(5))
			expect(transform h, is equal to(7))
			expect(transform i, is equal to(1))
		})
		this add("reflect X", func {
			transform := this transform0 reflectX()
			expect(transform a, is equal to(-3))
			expect(transform b, is equal to(1))
			expect(transform c, is equal to(0))
			expect(transform d, is equal to(-2))
			expect(transform e, is equal to(1))
			expect(transform f, is equal to(0))
			expect(transform g, is equal to(-5))
			expect(transform h, is equal to(7))
			expect(transform i, is equal to(1))
		})
		this add("reflect Y", func {
			transform := this transform0 reflectY()
			expect(transform a, is equal to(3))
			expect(transform b, is equal to(-1))
			expect(transform c, is equal to(0))
			expect(transform d, is equal to(2))
			expect(transform e, is equal to(-1))
			expect(transform f, is equal to(0))
			expect(transform g, is equal to(5))
			expect(transform h, is equal to(-7))
			expect(transform i, is equal to(1))
		})
		this add("createSkewingX", func {
			skewingX := IntTransform2D createSkewingX(4.0f * Float pi / 3.0f)
			expect(skewingX a, is equal to(1))
			expect(skewingX b, is equal to(0))
			expect(skewingX c, is equal to(0))
			expect(skewingX d, is equal to(-0))
			expect(skewingX e, is equal to(1))
			expect(skewingX f, is equal to(0))
			expect(skewingX g, is equal to(0))
			expect(skewingX h, is equal to(0))
			expect(skewingX i, is equal to(1))
		})
		this add("createSkewingY", func {
			skewingY := IntTransform2D createSkewingY(5 * Float pi / 3.f)
			expect(skewingY a, is equal to(1))
			expect(skewingY b, is equal to(-0))
			expect(skewingY c, is equal to(0))
			expect(skewingY d, is equal to(0))
			expect(skewingY e, is equal to(1))
			expect(skewingY f, is equal to(0))
			expect(skewingY g, is equal to(0))
			expect(skewingY h, is equal to(0))
			expect(skewingY i, is equal to(1))
		})
		this add("determinant", func {
			expect(this transform0 determinant, is equal to(1))
			expect(this transform1 determinant, is equal to(27))
			expect(this transform2 determinant, is equal to(this transform1 determinant))
			expect(this transform3 determinant, is equal to(this transform0 determinant))
			expect(this transform4 determinant, is equal to(-200))
		})
	}
}

IntTransform2DTest new() run() . free()
