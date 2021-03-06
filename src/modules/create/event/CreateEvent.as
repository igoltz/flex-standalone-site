package modules.create.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	public class CreateEvent extends CairngormEvent
	{
		
		public static const ADD_EXERCISE:String = "addExercise";
		public static const EDIT_EXERCISE:String = "editExercise";
		public static const LIST_LATEST_CREATIONS:String = "getLatestCreations";
		public static const LIST_CREATIONS:String = "listUserCreations";
		public static const DELETE_SELECTED_CREATIONS:String = "deleteSelectedVideos";
		public static const SET_EXERCISE_DATA:String = "setExerciseData";
		public static const SAVE_EXERCISE_MEDIA:String = "saveExerciseMedia";
		public static const LIST_EXERCISE_MEDIA:String = "listExerciseMedia";
		public static const GET_EXERCISE_MEDIA:String = "getExerciseMedia";
		public static const SET_DEFAULT_THUMBNAIL:String = "setDefaultThumbnail";
		public static const DELETE_MEDIA:String = "deleteMedia";
		public static const GET_EXERCISE_PREVIEW:String = "getExercisePreview";
		public static const PUBLISH_EXERCISE:String = "publishExercise";
		
		public var params:Object;
		
		public function CreateEvent(type:String, params:Object=null)
		{
			super(type);
			this.params = params;
		}
		
		override public function clone():Event {
			return new CreateEvent(type, params);
		}
	}
}