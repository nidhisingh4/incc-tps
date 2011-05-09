idSujeto=input('\nPor favor, ingrese su ID y presione Enter \n','s');

window = Screen(0, 'OpenWindow');
%letras=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','�','o','p','q','r','s','t','u','v','w','x','y','z'];
letras=['a';'b';'c';'d';'e';'f';'g';'h';'i';'j';'k';'l';'m';'n';'�';'o';'p';'q';'r';'s';'t';'u';'v';'w';'x';'y';'z']; %PONER �!!!
mayuscula=1;
minuscula=0;
maxBlocks=1;		% Se har�n 100 bloques
estimPorBlock=10; 	% 270 est�mulos random por bloque
%burbujas=zeros(27,3,2);

mbienvenida = imread('./bienvenida.png');
mcruz = imread('./cruz.png');
mpresionetecla = imread('./presione_tecla.png');
%mletraPrueba= imread('./estimulos/x_3_may_0.pgm');

aciertos=0;
e=1;

textura=Screen('MakeTexture', window, mbienvenida);
Screen('DrawTexture', window, textura);
Screen('Flip',window);
KbWait; % Presione cualquier tecla para continuar
Screen('Close', textura);

for b=1:maxBlocks
	esMayuscula=round(rand());
	burbujas=18;

	while mod(e,estimPorBlock) ~=0
	    textura=Screen('MakeTexture', window, mcruz);
	    Screen('DrawTexture', window, textura);
	    Screen('Flip',window);
	    WaitSecs(0.5);
	    Screen('Close', textura);
	    letra=round(rand()*26+1); 		%Devuelve un id de letra con una letra entre a-z ([1..27])
	    tipografia=round(rand()*2+1);	%Devuelve el id de una tipograf�a de las utilizadas ([1..4])
	    
	    if mod(e,estimPorBlock)>(estimPorBlock/2)
		mayuscula=esMayuscula;
	    else
		mayuscula=mod(esMayuscula + 1,2);
	    end

	    if mayuscula==1
		mayStr='may';
	    else
		mayStr='min';
        end
        
        [m1,m2,m3,m4,m5]=generarMascaras(burbujas);	%Devuelve un vector de 5 m�scaras con la cantidad de burbujas especificada, y de acuerdo a las bandas predefinidas
        nombreArchivo=[deblank(letras(letra,:)),'_',int2str(tipografia),'_',mayStr,'_0.pgm'];
	    [f1,f2,f3,f4,f5,f6] = generarFiltros(strcat('./estimulos/',nombreArchivo));
	    mletra1  = generarEstimulo(m1,m2,m3,m4,m5,f1,f2,f3,f4,f5,f6); %Devuelve una matriz con la imagen generada de la letra en may/min para la tipografia especificada, utilizando las m�scaras indicadas
        
	    mletra  = imread('c:\temp\letra.pgm');
	    textura = Screen('MakeTexture', window, mletra);
	    Screen('DrawTexture', window, textura);    
	    Screen('Flip',window);	    
	    WaitSecs(0.2);
	    Screen('Close', textura);
	    textura=Screen('MakeTexture', window, mpresionetecla);
	    Screen('DrawTexture', window, textura);    
	    Screen('Flip',window);
	    Screen('Close', textura);
	    %KbWait;
        % RECIBIR RESPUESTA
	    [secs,tecla,deltasecs] = KbPressWait();
	    teclaNombre = KbName(tecla);
	    e=e+1;
        % GUARDAR los valores obtenidos (m�scaras, letra del est�mulo, letra predicha, tiempo transcurrido en responder)
	    if deblank(letras(letra,:)) == teclaNombre
		aciertos=aciertos+1;
	    end
	    if aciertos/e < 0.52 % Si la el porcentaje de aciertos es menor a 52%, se agrega una burbuja para el pr�ximo
		burbujas=burbujas+1;
	    end
	end
	e=e+1;
end

Screen('CloseAll');