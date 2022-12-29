% Create a video file reader
video_reader = VideoReader('D:\bad\ba.mp4');

% Set the frame rate and frame time
fps = 15;
frametime = 1/fps;

% Initialize the output variable
output = struct('x', {}, 'y', {});

% Read and process each frame until the video is finished
i = 1;
while hasFrame(video_reader)
    % Read the next frame
    I = readFrame(video_reader);
    
    % Convert the frame to grayscale
    img = rgb2gray(I);
    
    % Find edges using different algorithms
    sobel_edges = edge(img,'sobel');
    prewitt_edges = edge(img,'prewitt');
    roberts_edges = edge(img,'roberts');
    log_edges = edge(img,'log');
    canny_edges = edge(img,'canny');
    
    % Find edges using fuzzy logic
    fuzzy_edges = fuzzy(img);
    
    % Find the x and y coordinates of the edges
    [x,y] = find(sobel_edges==1);
    output(i).sobel_x = x;
    output(i).sobel_y = y;
    
    [x,y] = find(prewitt_edges==1);
    output(i).prewitt_x = x;
    output(i).prewitt_y = y;
    
    [x,y] = find(roberts_edges==1);
    output(i).roberts_x = x;
    output(i).roberts_y = y;
    
    [x,y] = find(log_edges==1);
    output(i).log_x = x;
    output(i).log_y = y;
    
    [x,y] = find(canny_edges==1);
    output(i).canny_x = x;
    output(i).canny_y = y;
    
    [x,y] = find(fuzzy_edges==1);
    output(i).fuzzy_x = x;
    output(i).fuzzy_y = y;
    
    % Increment the frame counter
    i = i + 1;
end

% Set the output video file name and frame rate
output_filename = 'D:\bad\edgeXXX.mp4';
output_fps = 15;

% Create a video writer object
video_writer = VideoWriter(output_filename, 'MPEG-4');
video_writer.FrameRate = output_fps;
open(video_writer);

% Display the processed frames
disp("Saving...");
disp(length(output))
for i = 1:length(output)
    tic;
    
    % Plot the edges for each algorithm in a subplot
    subplot(2,3,1);
    scatter(output(i).sobel_y,-output(i).sobel_x,'.');
    axis([0 480 -360 0]);
    title('Sobel');
    
    subplot(2,3,2);
    scatter(output(i).prewitt_y,-output(i).prewitt_x,'.');
    axis([0 480 -360 0]);
    title('Prewitt');
    
    subplot(2,3,3);
    scatter(output(i).roberts_y,-output(i).roberts_x,'.');
    axis([0 480 -360 0]);
    title('Roberts');
    
    subplot(2,3,4);
    scatter(output(i).log_y,-output(i).log_x,'.');
    axis([0 480 -360 0]);
    title('LoG');
    
    subplot(2,3,5);
    scatter(output(i).canny_y,-output(i).canny_x,'.');
    axis([0 480 -360 0]);
    title('Canny');
    
    subplot(2,3,6);
    scatter(output(i).fuzzy_y,-output(i).fuzzy_x,'.');
    axis([0 480 -360 0]);
    title('Fuzzy Logic');
    
    % Capture the current figure and write it to the video file
    frame = getframe(gcf);
    writeVideo(video_writer, frame);
    
    pause(frametime - toc);
    disp(i)
end

% Close the video writer object
close(video_writer);
disp("Finished!");

function edges = fuzzy(img)
    % Define a threshold for detecting edges
    threshold = 10;
    
    % Initialize the output image
    edges = zeros(size(img));
    
    % Loop through each pixel in the image
    for i = 1:size(img,1)
        for j = 1:size(img,2)
            % Compare the intensity of the current pixel to that of its neighbors
            if i > 1 && abs(img(i,j) - img(i-1,j)) > threshold
                edges(i,j) = 1;
            elseif j > 1 && abs(img(i,j) - img(i,j-1)) > threshold
                edges(i,j) = 1;
            end
        end
    end
end
