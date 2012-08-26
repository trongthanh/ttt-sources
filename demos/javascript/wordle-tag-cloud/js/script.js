/* ============ MAIN SCRIPT ============== */
var main = (function (win) {
    //global
    var doc = win.document,
        canvas = doc.getElementById('drawing-canvas'),
        ctx = canvas.getContext('2d');

    //make canvas full viewport
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;

    //debug
    window.container = doc.getElementById('main-container');

    //member
    this.text = 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumyeirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diamvoluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumyeirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diamvoluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumyeirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diamvoluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumyeirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diamvoluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumyeirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diamvoluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consete';

    this.renderWordle = function () {
        var wordle = this.wordle,
            sortResult = TextUtil.countWordOccurance(this.text);
        if (typeof(wordle) !== 'undefined') {
            wordle.dispose();
        } 
        wordle = new WORDLEJS.Wordle(ctx);
        wordle.setWords(sortResult, 200);

        wordle.doLayout();

        this.wordle = wordle;
    };
    
    // var sortResult = TextUtil.countWordOccurance('one two three four, four three! four two three four.');

    

    var gui = new dat.GUI();
    gui.add(this, 'text');
    gui.add(this, 'renderWordle');
    // gui.add(text, 'displayOutline');
    // gui.add(text, 'explode');

}(this));