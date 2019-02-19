/**
 * @copyright 2016 Andrea Guarinoni
 */

$(function() {

    // cached selector for better performance
    var $mainContainer = $('#main-container'),
        $letterWrapper = $('.letterWrapper'),
        $letters       = $('.letter'),
        $scenarioBtn   = $('.scenarioBtn'),
        $scenarios     = $('.scenario'),
        $dimmer        = $('.dimmer');

    var orientation  = '',
        colorBg      = ['#003DFF', '#00CE62', '#0B6997', '#ECFF31', '#FCDBCA', '#FF3333', '#ADA400'];

    // define grids
    var lettersGridH = {},
        lettersGridV = {};

    var idleTime   = 0,
        crazyTimer = null;

    /**
     * Calculate grid sizes in % unit, according to current screen size
     */
    var calculateGrids = function(){
        var letterWidth  = 100 * $letters.width() / $letterWrapper.width(),
            letterHeight = 100 * $letters.height() / $letterWrapper.height();

        lettersGridH = {
            0: { minX: 1,  maxX: 19-letterWidth, minY: 0, maxY: 99-letterHeight },
            1: { minX: 20, maxX: 39-letterWidth, minY: 0, maxY: 99-letterHeight },
            2: { minX: 40, maxX: 59-letterWidth, minY: 0, maxY: 99-letterHeight },
            3: { minX: 60, maxX: 79-letterWidth, minY: 0, maxY: 99-letterHeight },
            4: { minX: 80, maxX: 99-letterWidth, minY: 20, maxY: 99-letterHeight }
        };
        lettersGridV = {
            0: { minX: 1,   maxX: 79-letterWidth,  minY: 0,  maxY: 29-letterHeight },
            1: { minX: 1,   maxX: 49-letterWidth,  minY: 30, maxY: 59-letterHeight },
            2: { minX: 50,  maxX: 99-letterWidth,  minY: 30, maxY: 59-letterHeight },
            3: { minX: 1,   maxX: 49-letterWidth,  minY: 60, maxY: 99-letterHeight },
            4: { minX: 50,   maxX: 99-letterWidth, minY: 60, maxY: 99-letterHeight }
        };
    };

    /**
     * Check window aspect ratio
     * @returns {boolean}
     */
    var isLandscape = function(){
        return $(window).width() >= $(window).height();
    };

    /**
     * Generate a random number in a selected interval with a selected increment
     * @param {number} from
     * @param {number} to
     * @param {number} increment
     * @returns {number} random number within the selected interval
     */
    var randomFromTo = function (from, to, increment) {
        var steps = Math.floor((to - from) / increment);
        return Math.floor(Math.random() * (steps + 1)) * increment + from;
    };

    /**
     * Set random position for letters
     * @param {object} grid
     * @param {bool}    animate
     */
    var randomizeLetters = function(grid, animate) {
        var timeout = null;
        if (animate) {
            $letters.removeClass('no-transitions');
            $letterWrapper.redraw();
        }

        $letters.each(function(index) {
            $(this).css("top", randomFromTo(grid[index]['minY'], grid[index]['maxY'], 1) + '%');
            $(this).css("left", randomFromTo(grid[index]['minX'], grid[index]['maxX'], 1) + '%');
            $(this).find('.letterImg').css('transform', 'rotate(' + randomFromTo(0, 270, 90) + 'deg)');
        });

        if (animate) {
            if (timeout) clearTimeout(timeout);
            timeout = setTimeout(function() {
                $letters.addClass('no-transitions');
            }, 500);
        }
    };

    /**
     *
     * @param evt
     */
    var switchScenario = function(evt){
        evt.preventDefault();
        var $currentScenario = $scenarios.filter(':visible'),
            switchLayer      = function($scenario){
                var $layers        = $scenario.find('.layer'),
                    $selectedLayer = $($layers.get(randomFromTo(0, $layers.length - 1, 1)));
                // set a layer
                $layers.hide();
                // animate '.in' contents
                $selectedLayer.find(".in").stop(true, true).hide().each(function(i) {
                    $(this).delay(i*300).fadeIn(300);
                });
                $scenario.find('.layer-mobile .img').each(function(){
                    $(this).css('top', randomFromTo(($('header').height() + 10), $mainContainer.height() - 210 - 10, 1) + 'px');
                });
                $selectedLayer.show();
            };

        if (!$currentScenario.length) {
            // show first scenario
            $scenarios.stop(true, true).fadeOut(500).promise().done(function(){
                var $scenario = $($scenarios.get(0));
                switchLayer($scenario);
                $scenario.fadeIn(500);
            });
        }
        else if ($currentScenario.hasClass('first')) {
            // show second scenario
            $scenarios.stop(true, true).fadeOut(500).promise().done(function(){
                var $scenario = $($scenarios.get(1));
                switchLayer($scenario);
                $scenario.fadeIn(500);
            });
        }
        else if ($currentScenario.hasClass('second')) {
            if ($mainContainer[0].style.backgroundColor == '') {
                // set a colored background
                var randomColor = colorBg[randomFromTo(0, colorBg.length - 1, 1)];
                $mainContainer[0].style.backgroundColor = randomColor;
                $dimmer.css('background-color', randomColor)
                    .css('background-color', $dimmer.css('background-color').replace(')', ', 0.85)'));
            }
            else {
                $mainContainer[0].style.backgroundColor = '';
                $dimmer.css('background-color', '');
                $scenarios.stop(true, true).fadeOut(500).promise().done(function(){
                    reset(true, true);
                });
            }
        }
    };

    /**
     *
     * @param evt
     * @param forced
     */
    var reset = function(evt, forced){
        if (forced === true) orientation = '';
        if ((!orientation || orientation == 'portrait') && isLandscape()) {
            // switching to landscape
            orientation = 'landscape';
            calculateGrids();
            randomizeLetters(lettersGridH, evt ? true : false);
        }
        else if ((!orientation || orientation == 'landscape') && !isLandscape()) {
            // switching to portrait
            orientation = 'portrait';
            calculateGrids();
            randomizeLetters(lettersGridV, evt ? true : false);
        }
    };

    /**
     *
     */
    var initIdleEffect = function() {
        var $spiral   = $('.spiral'),
            audio     = undefined,
            isRunning = false;
        var incrementIdleTime = function(){
            idleTime++;
            if (idleTime > 9) startCrazyEffects(); // after 10 min of inactivity
        };
        var startCrazyEffects = function() {
            if (!isRunning) {
                //$spiral.fadeIn(2000);
                //$letters.addClass('animated');
                //if (!audio) audio = new Audio('./audio/ge-conga.mp3');
                //audio.loop = true;
                // if (!audio) audio = new Audio('./audio/vedet.ogg');
                // audio.play();
                // isRunning = true;
            }
        };
        var stopCrazyEffects = function() {
            if (isRunning) {
                //$spiral.fadeOut(500);
                //$letters.removeClass('animated');
                //audio.pause();
                isRunning = false;
            }
        };

        setInterval(incrementIdleTime, 60000);
        $(document).on('mousemove keypress', function(){
            idleTime = 0;
            stopCrazyEffects();
        });
    };


    $letters.filter(".in").hide().each(function(i) {
        $(this).delay(i*250).fadeIn(500);
    });

    $(".letter").draggable({
        //stack: ".letter",
        containment: ".letterWrapper"
    });

    $scenarios.find('.img').draggable({
        containment: "#contents"
    });

    reset();
    initIdleEffect();

    // set event handlers
    $scenarioBtn.on('click', switchScenario);
    $(window).on('resize', reset);
    $letters.find('.letterImg').on('mouseenter', function(){ $(this).css('transform', 'rotate(' + randomFromTo(0, 270, 90) + 'deg)') });

});


