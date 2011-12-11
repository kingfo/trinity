package
{
	public class Player
	{
		public var currentlyPlayingSong:Song;
		public var isPlaying:Boolean;
	
		public function play(song) {
			currentlyPlayingSong = song;
			isPlaying = true;
		}
		
		public function pause() {
			isPlaying = false;
		}
		
		public function resume() {
			if (isPlaying) {
		    	throw new Error("song is already playing");
		  	}
		
		  	isPlaying = true;
		}
		
		public function makeFavorite() {
			currentlyPlayingSong.persistFavoriteStatus(true);
		}
	}
}