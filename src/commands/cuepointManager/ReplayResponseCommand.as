package commands.cuepointManager
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import components.videoPlayer.VideoRecorder;
	
	import vo.CueObject;

	public class ReplayResponseCommand implements ICommand
	{
		private var VP:VideoRecorder;
		public var cue:CueObject;
		
		public function ReplayResponseCommand(cue:CueObject, subHolder:VideoRecorder)
		{
			this.VP = subHolder;
			this.cue = cue;
		}

		public function execute(event:CairngormEvent):void
		{
			if(cue)
			{
				VP.setSubtitle(cue.text, cue.textColor);
				var time:Number = cue.endTime - cue.startTime as Number;
				VP.startTalking(cue.role, time);
			}
			else
				VP.setSubtitle('');
		}	
	}
}