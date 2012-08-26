//util

// usage: log('inside coolFunc', this, arguments);
// paulirish.com/2009/log-a-lightweight-wrapper-for-consolelog/
window.log = function(){
  log.history = log.history || [];   // store logs to an array for reference
  log.history.push(arguments);
  if(this.console) {
    arguments.callee = arguments.callee.caller;
    var newarr = [].slice.call(arguments);
    (typeof console.log === 'object' ? log.apply.call(console.log, console, newarr) : console.log.apply(console, newarr));
  }
};

// make it safe to use console.log always
(function(b){function c(){}for(var d="assert,clear,count,debug,dir,dirxml,error,exception,firebug,group,groupCollapsed,groupEnd,info,log,memoryProfile,memoryProfileEnd,profile,profileEnd,table,time,timeEnd,timeStamp,trace,warn".split(","),a;a=d.pop();){b[a]=b[a]||c}})((function(){try
{console.log();return window.console;}catch(err){return window.console={};}})());

window.trace = function(line, str) {
  window.document.getElementById('line' + line).innerHTML = str;
};

/**
 * TextUtil
 */
var TextUtil = {
  countWordOccurance: function (text) {
    // Remove punctuations, non-word characters...
    //note: this case also remove Vietnamese unicode characters, improve later when needed
    text = text.replace(/[^A-Za-z0-9_\-\s]/g, '');

    var words = text.split(/\s+/);

    var i, il, w,
        wordsObject = {};

    for (i = 0, il = words.length; i < il; i++) {
      w = words[i];

      if (wordsObject[w] && typeof(wordsObject[w]) === 'number') {
        wordsObject[w] ++;
      } else {
        wordsObject[w] = 1;
      }
    }

    //tranfer to array in order to sort
    var result = [];
    for (var item in wordsObject) {
      if(wordsObject.hasOwnProperty(item)) {
        result.push({ text: item, count:wordsObject[item] });
      }
    }

    //bigger count stay at top
    result.sort(function (wordA, wordB) {
      return wordB.count - wordA.count;
    });

    return result;
  }
};

/**
 * Random util
 */
var Random = {
    /**
     * Creates a randomized boolean
     * @return
     */
		getRandomBoolean: function () {
			return Math.random() >= 0.5;
		},

    /**
     * Return random color number
     */
    getRandomColor: function () {
      return Math.floor(Math.random() * 0xFFFFFF);
    }

};

