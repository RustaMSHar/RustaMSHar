create table Itog 
( 

A number (38), 
B number (38), 
C number (38),
X1 float, 
X2 float

);


set serveroutput on 

declare 
		a number (38);
		b number (38);
		c number (38);
		signC varchar2 := '&signC'; 
		
		prec number(4) :=3 ;
		
		cursor c1 
		is 
		select *
		from itog;
		c1string c1%ROWTYPE;
		
		
		
								
						FUNCTION findA ( buf number) 

						return number 

						is 
							bufA number (38);
						begin 
							bufA: = buf;
							for i in 2..5 LOOP
							bufA := bufA + i ;
							end loop;
							return bufA;
						END findA ;

								FUNCTION findB (buf number) 
								return number 
								is 
									bufB number (38):
								begin 
									bufB := buf;
									for i in reverse 3..6 loop 
									bufB := bufB - i ;
									end loop; 
									return bufB;
								END findB;

											FUNCTION findC ( buf number) 
											return number 	
											is 
												bufC number(38);
											begin 
												bufC := buf;
												for i in 1..4 LOOP
												bufC := buf + 2*i;
												end loop; 
												
												if signC = '-' then 
													bufC :=-bufC;
													
												return bufC;
											END findC;

		FUNCTION print ( styleX VARCHAR2, x number)
		return varchar2
		IS
		begin 
				if x > 0 and x < 1 then 
						dbms_out.put_line(styleX || '0' || to_char(round(x , prec)) || ';');
				elsif x > - 1 and x < 0 then 
						dbms_out.put_line(styleX || '-0' || to_char(round(-x , prec)) || ';');
				else 
						dbms_out.put_line(styleX || to_char(round(x , prec)) || ';');
				end if;
				
				if styleX = 'x = ' or styleX = 'x1 = ' then 
							update itog 
							set X1 = x 
							where A = c1string.A and B = c1string.B and C = c1string.C;
							
							
							update itog
							set X2 = x 
							where A = c1string.A and B = c1string.B and C = c1string.C;
							
				ELSIF styleX = 'x2 = ' then 
							update itog 
							set X2 = x
							where A = c1string.A and B = c1string.B and C = c1string.C;
				end if;
		END print;

		PROCEDURE kvadrat( a number , b number, c number , prec number) 
		is 
			d number (38) := c1string.b**2 + 4*c1string.a*c1string.c;
		begin 
			if c1string.a = 0 then 
							if c1string.b !=0 then 
									print ( 'x = ' , (-c1string.c / c1string.b )); 
							elsif c1string.c = 0 then 
									dbms_out.put_line ( 'x - any number ' ) ;
							else 
									dbms_out.put_line ( ' net korney') ;
							end if;
				
				else 
						
						if d < 0 then 
							dbms_out.put_line ( ' net korney ' ) ;
						elsif d = 0 then 
								print ( 'x = ', (-c1string.b/ (2*c1string.a) ));
						else 	
								print( 'x1 = ', ((-c1string.b - sqrt(d)) / (2*c1string.a)));
								print( 'x2 = ', ((-c1string.b + sqrt(d)) / (2*c1string.a)));
						end if;
				end if;
		END kvadrat;



	begin 



		dbms_output.enable;
		
		for i in 1..3 loop 
				a:= findA(i);
				b:= findB(i+4);
				c:= findC(i-5);
				
				insert into itog (A , B , C)
				values ( a,b,c);
		end loop;
		
		open c1;
		LOOP	
			FETCH c1 into c1string;
			exit when c1%notfound;
			dbms_out.put_line ( 'a= ' || c1string.a || 'b =' || c1string.b || 'c= ' || c1string .c || ';');
			kvadrat ( a,b,c,prec) ;
		END loop;
		close c1;
	end;

/
