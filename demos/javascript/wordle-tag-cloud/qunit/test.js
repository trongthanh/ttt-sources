
module("Uitilities");

test("Test TextUtil", function () {
	var str = "one two three four, four three! four two three four.";
	var result = TextUtil.countWordOccurance(str);

	//total 4 different word
	deepEqual(result.length, 4);
	//check words count and order
	deepEqual(result[0].count, 4);
	deepEqual(result[0].text, "four");
	deepEqual(result[1].count, 3);
	deepEqual(result[1].text, "three");
	deepEqual(result[2].count, 2);
	deepEqual(result[2].text, "two");
	deepEqual(result[3].count, 1);
	deepEqual(result[3].text, "one");
});

test("Test Random.getRandomBoolean", function () {
	var trueCount = 0,
		falseCount = 0;

	for (var i = 0; i < 10000; i++) {
		if (Random.getRandomBoolean()) {
			trueCount ++;
		} else {
			falseCount ++;
		}
	}

	//balance of true/dalse is 50%
	ok(trueCount > 450);
	ok(falseCount > 450);
});

test("Test Random.getRandomInt", function () {
	var from = 10,
		to = 20,
		valObj = {},
		val,
		outOfRange,
		valSkipped;

	//random must return all FROM - TO and no number outside
	for (var i = 0; i < 10000; i++) {
		val = Random.getRandomInt(from, to);
		valObj[val] = true;

		if (val < from || val > to) {
			outOfRange = true;
			break;
		}
	}

	for (var j = from; j <= to; j++) {
		if (valObj[j] === undefined) {
			valSkipped = true;
			break;
		}
	}

	ok(!outOfRange, 'no value out of range');
	ok(!valSkipped, 'no value skipped');
});

test("Test Random.getRandomSequence", function () {
	var from = 7,
		to = 17,
    orderedSeq,
		valArr,
    val,
		result,
    inOrder,
		outOfRange,
		valSkipped;

	//number of trials
	for (var trial = 0; trial < 5; trial++) {
    //random must return all FROM - TO and no number outside
		result = Random.getRandomSequence(from, to);

    //get normal order seq
    orderedSeq = [];
    for (var o = from; o <= to; o++) {
      orderedSeq.push(o); 
    }

    if (result.join('') === orderedSeq.join('')) {
      inOrder = true;
      break;
    }

    valArr = [];
    for (var i = 0; i < result.length; i++) {
      val = result[i];

      valArr[val] = true; //for value in range checking later
      
      if (val < from || val > to) {
        outOfRange = true;
        break;
      }
		}

    for (var j = from; j <= to ; j++) {
      if (typeof(valArr[j]) === 'undefined') {
        valSkipped = true;
        break;
      }
    }

    
  }

  ok(!inOrder, 'sequence is in order (should not)');
	ok(!outOfRange, 'value out of range');
	ok(!valSkipped, 'value skipped');
});

module("Facility Classes");

test("Test Rectangle", function () {
	var rect = new WORDLEJS.Rectangle(10, 20, 30, 40);

	deepEqual(rect.x, 10);
	deepEqual(rect.y, 20);
	deepEqual(rect.width, 30);
	deepEqual(rect.height, 40);
	deepEqual(rect.getRight(), 40);
	deepEqual(rect.getBottom(), 60);
	deepEqual(rect.getCenterX(), 25); //10 + 30/2
	deepEqual(rect.getCenterY(), 40); //20 + 40/2
});

test("Test WordRectangle.intersect", function () {
	var rect1 = new WORDLEJS.Rectangle(20, 20, 40, 40),
		collideRect = new WORDLEJS.Rectangle(30, 30, 60, 40),
		nonCollideRect = new WORDLEJS.Rectangle(70, 70, 30, 20);

	deepEqual(rect1.intersects(collideRect), true);
	deepEqual(rect1.intersects(nonCollideRect), false);
});

test("Test Word", function () {
	var initObj = {
		text: 'hello'

	},
		word = new WORDLEJS.Word(initObj);
	ok(true);
});