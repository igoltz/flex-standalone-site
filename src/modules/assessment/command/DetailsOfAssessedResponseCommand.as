package modules.assessment.command
{
	import business.EvaluationDelegate;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import modules.assessment.event.EvaluationEvent;
	
	import model.DataModel;
	
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	import mx.utils.ArrayUtil;
	import mx.utils.ObjectUtil;
	
	import view.common.CustomAlert;
	
	public class DetailsOfAssessedResponseCommand implements ICommand, IResponder
	{
		private var dataModel:DataModel = DataModel.getInstance();
		private var cgEvent:CairngormEvent;
		
		public function execute(event:CairngormEvent):void
		{
			cgEvent = event;
			new EvaluationDelegate(this).detailsOfAssessedResponse((event as EvaluationEvent).responseId);
		}
		
		public function result(data:Object):void
		{
			var result:Object=data.result;
			var resultCollection:ArrayCollection;
			
			if (result is Array && (result as Array).length > 0 )
			{
				resultCollection=new ArrayCollection(ArrayUtil.toArray(result));
				//Set the data in the application's model
				dataModel.responseAssessmentData = resultCollection;
			} else {
				dataModel.responseAssessmentData = new ArrayCollection();
			}
			if(cgEvent.type == EvaluationEvent.DETAILS_OF_RESPONSE_ASSESSED_TO_USER)
				dataModel.responseAssessmentDataRetrieved = !dataModel.responseAssessmentDataRetrieved;
			if(cgEvent.type == EvaluationEvent.DETAILS_OF_RESPONSE_ASSESSED_BY_USER)
				dataModel.detailsOfResponseAssessedByUserRetrieved = !dataModel.detailsOfResponseAssessedByUserRetrieved;
		}
		
		public function fault(info:Object):void
		{
			trace(ObjectUtil.toString(info));
			CustomAlert.error(ResourceManager.getInstance().getString('myResources','ERROR_WHILE_RETRIEVING_RESPONSES_ASSESSMENTS'))
		}
	}
}