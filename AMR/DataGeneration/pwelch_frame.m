function out=pwelch_frame(in)
out=zeros(1,size(in,2));
for i=1:size(in,1)
    out=out+fft(in(i,:));
end
out=out/size(in,1);
out=fftshift(out);

