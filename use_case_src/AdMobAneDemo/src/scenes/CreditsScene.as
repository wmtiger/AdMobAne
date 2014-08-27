package scenes
{
	// Game UI Models Includes
	import models.ui.SceneBackground;
	import models.ui.SceneHeader;
	import models.ui.controls.BackButton;
	import models.ui.controls.Scroller;
	
	// Starling Includes
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	// Game Utils Includes
	import utils.AdsManager;
	import utils.SpriteUtl;
	
	/**
	 * Credits Scene Class<br/>
	 * The class will construct and manage the Credits Scene
	 * 
	 * @author Code Alchemy
	 **/
	public class CreditsScene extends Sprite
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[CreditsScene] ';
		
		// Hard-coded Credits Data 
		private const CDATA:Array = [
			{
				"title": "Design & Development",
				"entries": [
					"Code Alchemy",
					"(Mini game base on scaffold_mobile",
					" project by Daniel)"
				]
			},
			{
				"title": "IDE",
				"entries": [
					"Flash Builder 4.7",
					"FlashDevelop 4.6.2"
				]
			},
			{
				"title": "Game Engine",
				"entries": [
					"Starling 1.5.1 by Gamua"
				]
			},
			{
				"title": "Additional Libraries",
				"entries": [
					"Feathers 1.3.1 by Josh Tynjala"
				]
			},
			{
				"title": "Native Extensions",
				"entries": [
					"AdMobAne by Code Alchemy"
				]
			},
			{
				"title": "Development Tools",
				"entries": [
					"TexturePacker by CodeAndWeb",
					"ATF Tools by Adobe"
				]
			},
			{
				"title": "Artwork (well, Art...)",
				"entries": [
					"Code Alchemy"
				]
			},
			{
				"title": "Special Thanks",
				"entries": [
					"Starling Community",
					"GitHub Community",
					"Stack Overflow Community",
					"and most of all...",
					"My wife and son",
					"for their patience and inspiration"
				]
			}
		]
		
		// Hard-coded Credits Breaker 
		private const BREAKER:String = ".........................................................";			
		
		// =================================================================================================
		//	Constructors Functions
		// =================================================================================================
		
		/** 
		 * Credits Scene constructor
		 * 
		 **/
		public function CreditsScene()
		{
			// Debug Logger
			Root.log(LOG_TAG,"Constructor");
			
			// Add loading and unloading event listeners
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		/** 
		 * Event listener for Scene added to stage <br/>
		 *   
		 * @param e Event Object
		 **/
		private function onAddedToStage(e:Event):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onAddedToStage");
			
			// Remove unnecessary event listeners
			removeEventListeners(Event.ADDED_TO_STAGE);
			// Init the scene
			init();
		}
		
		/** 
		 * Event listener for Scene removed from stage <br/>
		 *   
		 * @param e Event Object
		 **/
		private function onRemovedFromStage(e:Event):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onRemovedFromStage");
			
			// Remove all the event listeners
			removeEventListeners();
		}
		
		/** 
		 * Initialize the Credit Scene
		 *   
		 **/
		private function init():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"Initializing...");
			
			// Add the Scene Background
			var sceneBackground:SceneBackground = new SceneBackground();
			addChild(sceneBackground);
			
			// Add the Scene Header
			var sceneHeader:SceneHeader = new SceneHeader();
			addChild(sceneHeader);
			
			// Add the Back Button
			var BackBtn:BackButton = new BackButton();
			addChild(BackBtn);
			
			// Add the offline banner instance and activate the banner
			addChild(AdsManager.offlineBanner);
			AdsManager.activateAppBanner();
			
			// Create and Add the Scene Context
			var mainContext:Sprite = createMainContext();
			SpriteUtl.setPivot(mainContext,SpriteUtl.CENTER);
			var posY:uint = sceneHeader.height+((Constants.STAGE_HEIGHT-50-sceneHeader.height-BackBtn.height)/2);
			SpriteUtl.setPosition(mainContext,Constants.STAGE_WIDTH/2,posY,false);
			addChild(mainContext);
		}
		
		/** 
		 * Create the Scene main Context
		 *   
		 * @return Main context Sprite instance
		 **/
		private function createMainContext():Sprite
		{
			// Debug Logger
			Root.log(LOG_TAG,"createMainContext");
			// Console proprierty
			var elemOffset:uint = 2;
			// Create Container Elements
			var container:Sprite = new Sprite();
			// Create the credit window
			var contentBox:Image = new Image(Root.assets.getTexture(Constants.IMG_CREDITS_WIN));
			// Create the scroll Context
			var context:Sprite = createContext(contentBox.width-10, contentBox.height-10);
			
			// Set ContentBox Position
			SpriteUtl.setPivot(contentBox,SpriteUtl.TOP);
			SpriteUtl.setPosition(contentBox,contentBox.width/2,0,false);
			container.addChild(contentBox);
			
			// Set context Position
			SpriteUtl.setPivot(context,SpriteUtl.TOP);
			SpriteUtl.setPosition(context,contentBox.x,contentBox.y+5,false);
			container.addChild(context);
			
			// Return the Container
			return container;
		}

		/** 
		 * Initialize the Credit Context
		 *   
		 * @param width Content width
		 * @param height Content height
		 * 
		 * @return Context Sprite instance
		 **/
		private function createContext(width:uint,height:uint):Sprite
		{
			// Debug Logger
			Root.log(LOG_TAG,"createContext");
			// Console proprierty
			var elemOffset:uint = 2;
			// Create Container Elements
			var container:Sprite = new Sprite();
			// Create items records list
			var credits:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			for each (var credit:Object in CDATA)
			{
				// Create the Item Record
				var record:Sprite = getRecord(credit);
				// Skip incorrect records
				if (!record) continue;
				// Push the record to the list
				credits.push(record);
			}
			
			// Create the scroll list with the given records
			var sList:Scroller = new Scroller(credits);
			sList.setSize(width, height);
			sList.horizontalScrollPolicy = "off";
			
			// Add the Store list
			container.addChild(sList);
			
			// Return the Container
			return container;
		}
		
		/** 
		 * Create the Credit Record 
		 *   
		 * @return Record Sprite instance
		 **/
		private function getRecord(creditData:Object):Sprite
		{
			// Create the new Record
			var record:Sprite = new Sprite();
			
			// Create the Credit Title Text field
			var titleField:TextField	= new TextField(180, 20, creditData.title);
			titleField.fontName			= Constants.FONT_NAME;
			titleField.fontSize			= Constants.FONT_SIZE_SMALL;
			titleField.color			= Constants.COL_FONT_LIGHT;
			titleField.hAlign			= HAlign.CENTER;
			titleField.vAlign			= VAlign.TOP;
			SpriteUtl.setPivot(titleField,SpriteUtl.TOP);
			SpriteUtl.setPosition(titleField,300,0);
			record.addChild(titleField);
			
			// Entries parameters
			var entryField:TextField;
			var posY:uint = 30;
			// Create each Credit Entries Text field
			for each (var entry:String in creditData.entries)
			{
				entryField			= new TextField(300, 30, entry);
				entryField.fontName	= Constants.FONT_NAME;
				entryField.fontSize	= Constants.FONT_SIZE_BACK;
				entryField.color	= Constants.COL_FONT_LIGHT;
				entryField.hAlign	= HAlign.CENTER;
				entryField.vAlign	= VAlign.TOP;
				SpriteUtl.setPivot(entryField,SpriteUtl.TOP);
				SpriteUtl.setPosition(entryField,300,posY);
				record.addChild(entryField);
				posY += 40;
			}
			
			// Create the closing line brake
			var lineBreak:TextField	= new TextField(180, 20, BREAKER);
			lineBreak.fontName		= Constants.FONT_NAME;
			lineBreak.fontSize		= Constants.FONT_SIZE_LABEL;
			lineBreak.color			= Constants.COL_HIGHLIGHT_RED;
			lineBreak.hAlign		= HAlign.CENTER;
			lineBreak.vAlign		= VAlign.TOP;
			SpriteUtl.setPivot(lineBreak,SpriteUtl.TOP);
			SpriteUtl.setPosition(lineBreak,300,posY);
			record.addChild(lineBreak);
			
			// Return the record
			return record;
		}
	}
}