package commands.exercises
{
	import business.ExerciseDelegate;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.DataModel;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.utils.ArrayUtil;
	import mx.utils.ObjectUtil;
	
	import vo.ExerciseVO;
	
	public class GetRecordableExercisesCommand implements ICommand, IResponder
	{
		
		public function execute(event:CairngormEvent):void
		{
			new ExerciseDelegate(this).getRecordableExercises();
		}
		
		public function result(data:Object):void
		{
			var result:Object=data.result;
			var resultCollection:ArrayCollection;
			
			if (result is Array)
			{
				resultCollection=new ArrayCollection(ArrayUtil.toArray(result));
				
				if (!(resultCollection[0] is ExerciseVO))
				{
					Alert.show("The Result is not a well-formed object");
				}
				else
				{
					//Set the data to the application's model
					DataModel.getInstance().availableRecordableExercises=resultCollection;
					//Reflect the visual changes
					DataModel.getInstance().availableExercisesRetrieved.setItemAt(true, DataModel.RECORDING_MODULE);
				}
			} else {
				DataModel.getInstance().availableRecordableExercises.removeAll();
				DataModel.getInstance().availableExercisesRetrieved.setItemAt(true, DataModel.RECORDING_MODULE);
			}
		}
		
		public function fault(info:Object):void
		{
			Alert.show("Error while retreiving the exercises");
			trace(ObjectUtil.toString(info));
		}
	}
}