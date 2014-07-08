function [S,sample_rate]=my_esp_read(filename)
%   y=my_esp_read(filename)

fid=fopen(filename,'r','b');

packet_number=0;

while packet_number<500
    packet_number=packet_number+1;

    [packet_header,count]=fread(fid,1,'uint16');
    if count==0
        return
    end
    sample_count=fread(fid,1,'uint16');
    channel_count=fread(fid,1,'uint16');
    sample_rate=fread(fid,1,'uint16');

    y=zeros(channel_count,sample_count,'int16');
    
    for i=1:sample_count
        time_stamp(i)=fread(fid,1,'*uint64');
        y(:,i)=fread(fid,channel_count,'*int16');
    end

    packet_footer=fread(fid,1,'uint16');

    y=y.';
    S(packet_number).y=y;
    S(packet_number).time_stamps=time_stamp;
    S(packet_number).sample_count=sample_count;
    S(packet_number).channel_count=channel_count;
    S(packet_number).sample_rate=sample_rate;
end

fclose(fid);