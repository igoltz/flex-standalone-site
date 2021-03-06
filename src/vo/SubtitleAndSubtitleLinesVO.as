package vo
{
	[RemoteClass(alias="SubtitleAndSubtitleLinesVO")];
	[Bindable]
	public class SubtitleAndSubtitleLinesVO
	{
		public var id:int;
		public var mediaId:int;
		public var userName:String;
		public var language:String;
		public var translation:Boolean;
		public var addingDate:String;
		public var complete:Boolean;

		public var subtitleLines:Array;

		public function SubtitleAndSubtitleLinesVO(id:int=0, mediaId:int=0, userName:String=null, language:String=null, translation:Boolean=false, addingDate:String=null, complete:Boolean = false, subtitleLines:Array=null)
		{
			this.id=id;
			this.mediaId=mediaId;
			this.userName=userName;
			this.language=language;
			this.translation=translation;
			this.addingDate=addingDate;
			this.complete = complete;
			this.subtitleLines=subtitleLines;
		}

	}
}