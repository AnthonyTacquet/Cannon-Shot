package logic;

public class SoundFile {
    private String url = "";
    private String name = "";

    public SoundFile(){
    }

    public SoundFile(String url, String name){
        this.url = url;
        this.name = name;
    }

    public String getUrl(){
        return this.url;
    }

    public String getName(){
        return this.name;
    }

    public void setUrl(String url){
        this.url = url;
    }

    public void setName(String name){
        this.name = name;
    }
}
