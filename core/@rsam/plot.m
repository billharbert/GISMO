function handlePlot = plot(rsam_vector, varargin)
    % RSAM/PLOT plot rsam data
    % handle = plot(rsam_vector, varargin)
    % Properties include:
    %   yaxisType, h, addgrid, addlegend, fillbelow, plotspikes, plottransients, plottremor
    % to change where the legend plots set the global variable legend_ypos
    % a positive value will be within the axes, a negative value will be below
    % default is -0.2. For within the axes, log(20) is a reasonable value.
    % yaxisType is like 'logarithmic' or 'linear'
    % h is an axes handle (or an array of axes handles)
    % use h = generatePanelHandles(numgraphs)

    % Glenn Thompson 1998-2009
    %
    % % GTHO 2009/10/26 Changed marker size from 5.0 to 1.0
    % % GTHO 2009/10/26 Changed legend position to -0.2

    % parse variable input arguments
    p = inputParser;
    p.addParameter('addgrid',false);
    p.addParameter('addlegend', false);
    p.addParameter('fillbelow', false);

    %apparently unused options
    p.addParameter('yaxisType','logarithmic'); % or linear
    p.addParameter('h', []);

    p.parse(varargin{:});

    legend_ypos = -0.2;

    % colours to plot each station
    lineColour={[0 0 0]; [0 0 1]; [1 0 0]; [0 1 0]; [.4 .4 0]; [0 .4 0 ]; [.4 0 0]; [0 0 .4]; [0.5 0.5 0.5]; [0.25 .25 .25]};

    % Plot the data graphs
    figure
    for c = 1:length(rsam_vector)
        self = rsam_vector(c);
        hold on; 
        t = self.dnum;
        y = self.data;

        debug.print_debug(10,sprintf('Data length: %d',length(y)));
        %figure
        %if strcmp(rsam_vector(c).units, 'Hz')
        if strcmp('yaxisType','linear')
            
            % plot on a linear axis, with station name as a y label
            % datetick too, add measure as title, fiddle with the YTick's and add max(y) in top left corner
            if ~p.Results.fillbelow
                handlePlot = plot(t, y, '-', 'Color', lineColour{c});
            else
                handlePlot = fill([min(t) t max(t)], [min([y 0]) y min([y 0])], lineColour{c});
            end

            % if c ~= numel(rsam_vector)
            %     set(gca,'XTickLabel','');
            % end

            % yt=get(gca,'YTick');
            % ytinterval = (yt(2)-yt(1))/2; 
            % yt = yt(1) + ytinterval: ytinterval: yt(end);
            % ytl = yt';
            % ylim = get(gca, 'YLim');
            % set(gca, 'YLim', [0 ylim(2)],'YTick',yt);
            % %ylabelstr = sprintf('%s.%s %s (%s)', self.sta, self.chan, self.measure, self.units);
            ylabelstr = sprintf('%s', self.sta);
            ylabel(ylabelstr);
%             datetick('x','keeplimits');
            a = axis;
            datetick('x')
            set(gca,'XLim',[a(1) a(2)]);
            xlabel('Date/Time');
            
        else
            
            % make a logarithmic plot, with a marker size and add the station name below the x-axis like a legend
            y = log10(y);  % use log plots

            handlePlot = plot(t, y, '-', 'Color', lineColour{c},...
               'MarkerSize', 1.0);

            if strfind(self.measure, 'dr')
                %ylabel(sprintf('%s (cm^2)',self(c).measure));
                %ylabel(sprintf('D_R (cm^2)',self(c).measure));
                Yticks = [0.01 0.02 0.05 0.1 0.2 0.5 1 2 5 10 20 50 ];
                Ytickmarks = log10(Yticks);
                for count = 1:length(Yticks)
                    Yticklabels{count}=num2str(Yticks(count),3);
                end
                set(gca, 'YLim', [min(Ytickmarks) max(Ytickmarks)],...
                   'YTick',Ytickmarks,'YTickLabel',Yticklabels);
            end
            axis tight
            a = axis;
            datetick('x')
            set(gca,'XLim',[a(1) a(2)]);
%
            xlabel(sprintf('Date/Time starting at %s',datestr(self.snum)))
            ylabel(sprintf('log(%s)',self.units))
 
        end

%         if p.Results.addgrid
%             grid on;
%         end
%         if p.Results.addlegend && ~isempty(y)
%             xlim = get(gca, 'XLim');
%             legend_ypos = 0.9;
%             legend_xpos = c/10;    
%         end

    end
end