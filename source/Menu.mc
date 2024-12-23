import Toybox.Activity;
import Toybox.Weather;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;


class AnalogDelegate extends WatchUi.WatchFaceDelegate {

    function initialize() {
        WatchFaceDelegate.initialize();
    }
    function onPowerBudgetExceeded(powerInfo) {
    }
}


class AnalogSettingsViewTest extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize(null);

        // Generate a new Menu with a drawable Title
        Menu2.setTitle("Settings");
        Menu2.addItem(new WatchUi.MenuItem("Choose your race", null, "race", null));
        Menu2.addItem(new WatchUi.MenuItem("Data Fields", null, "datafields", null));
	}

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return false;
    }  

    function onDone() {
        WatchUi.popView(WatchUi.SLIDE_BLINK);
    }

    function onWrap(key as WatchUi.Key) {
        return true;
    }    

}


class Menu2TestMenu2Delegate extends WatchUi.Menu2InputDelegate { // Sub-menu Design

	public function initialize() {
        Menu2InputDelegate.initialize();
    }

	public function onSelect(item) as Void {

        if( item.getId().equals("race") ) { 

            var raceMenu = new WatchUi.Menu2({:title=>"Choose your race"});
            var RaceDrawable = new RaceSelection();
            RaceDrawable.initialize();
            raceMenu.addItem(new WatchUi.IconMenuItem("Race choosen:", raceAttributes[Storage.getValue(40)][:name], "race_choice", RaceDrawable, {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            raceMenu.addItem(new WatchUi.MenuItem("Apply", null, "race_apply", null));
            WatchUi.pushView(raceMenu, new Menu2TestMenu2Delegate(), WatchUi.SLIDE_UP );
        }
        else if( item.getId().equals("race_choice") ) {
            item.setSubLabel((item.getIcon() as RaceSelection).nextState());
        }
        else if( item.getId().equals("race_apply") ) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }

        else if( item.getId().equals("datafields") ) {

            var dataMenu = new WatchUi.Menu2({:title=>"Data Fields"});
            var drawableTopLeft = new DataFieldSelection(30);
            var drawableTopRight = new DataFieldSelection(31);
            var drawableMiddleLeft = new DataFieldSelection(32);
            var drawableMiddleRight = new DataFieldSelection(33);
        
            drawableTopLeft.initialize(30);
            drawableTopRight.initialize(31);
            drawableMiddleLeft.initialize(32);
            drawableMiddleRight.initialize(33);

            dataMenu.addItem(new WatchUi.IconMenuItem("Top left:", iconsDict[Storage.getValue(30)][:name], "topLeft", drawableTopLeft, {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            dataMenu.addItem(new WatchUi.IconMenuItem("Top right:", iconsDict[Storage.getValue(31)][:name], "topRight", drawableTopRight, {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            dataMenu.addItem(new WatchUi.IconMenuItem("Middle left:", iconsDict[Storage.getValue(32)][:name], "middleLeft", drawableMiddleLeft, {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            dataMenu.addItem(new WatchUi.IconMenuItem("Middle right:", iconsDict[Storage.getValue(33)][:name], "middleRight", drawableMiddleRight, {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));

            WatchUi.pushView(dataMenu, new Menu2TestMenu2Delegate(), WatchUi.SLIDE_UP );
        }
        else if( item.getId().equals("topLeft") ) {
            item.setSubLabel((item.getIcon() as DataFieldSelection).nextState(30));
        }
         else if( item.getId().equals("topRight") ) {
             item.setSubLabel((item.getIcon() as DataFieldSelection).nextState(31));
         }
        else if( item.getId().equals("middleLeft") ) {
            item.setSubLabel((item.getIcon() as DataFieldSelection).nextState(32));
        }
        else if( item.getId().equals("middleRight") ) {
            item.setSubLabel((item.getIcon() as DataFieldSelection).nextState(33));
        }
 else {
            WatchUi.requestUpdate();
        }  
	}

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }  
}

class RaceSelection extends WatchUi.Drawable {
    var mIndex;
    var mStates = raceAttributes.keys();
    
    function initialize() {
        Drawable.initialize({});
    }

    function nextState() {
        mIndex = Storage.getValue(40);
        mIndex++;
        
        if (mIndex >= mStates.size()) {
            mIndex = 0; // Wrap around to the first state
        }
        Storage.setValue(40, mIndex);
        return raceAttributes[mStates[mIndex]][:name];
    }
}

class DataFieldSelection extends WatchUi.Drawable {
    var mIndex;
    var mStates;

    function initialize(storageId) {
        Drawable.initialize({});
        mStates = iconsDict.keys();
        mIndex = Storage.getValue(storageId);
    }
    
    function nextState(storageId) {
        mIndex = Storage.getValue(storageId);
        mIndex++; // Prevents the incrementation of the index on the first run
        
        if (mIndex >= mStates.size()) {
            mIndex = 0; // Wrap around to the first state
        }
        Storage.setValue(storageId, mIndex);
        return iconsDict[mStates[mIndex]][:name];
    }

    function draw(dc) {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.clear();
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
			var iconsFont = Application.loadResource(Rez.Fonts.iconfont);
			var icon = iconsDict[mStates[mIndex]][:iconNumber];
            dc.drawText( dc.getWidth()/2, dc.getHeight()/3, iconsFont, icon , Graphics.TEXT_JUSTIFY_CENTER);
        }
}
