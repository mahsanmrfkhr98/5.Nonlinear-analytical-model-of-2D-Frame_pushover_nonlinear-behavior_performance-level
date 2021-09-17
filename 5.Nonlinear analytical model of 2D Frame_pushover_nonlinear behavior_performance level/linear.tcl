wipe all;
model BasicBuilder -ndm 2 -ndf 3
#step1
#define parameter
                 set NS                           3.0;
                 set NX                           4.0;
				 set NZ                           6.0;
				 set NP                           2.0;
				 set WB              [expr 30.0*12.0];
				 set HS              [expr 13.0*12.0];
				 set HBuilding         [expr $NS*$HS];
#define position of members
                set XPier1                       0.0;
                set XPier2        [expr $XPier1+$WB];	
                set XPier3        [expr $XPier2+$WB];
                set XPier4        [expr $XPier3+$WB];
                set XPier5        [expr $XPier4+$WB];	
                set XPDeltaPier   [expr $XPier5+$WB];	
                set YBase                        0.0;
                set YFloor2        [expr $YBase+$HS];
				set YFloor3      [expr $YFloor2+$HS];
				set YRoof        [expr $YFloor3+$HS];
				
#step2				
#define loads(psf)
				set DF            96.0;
		     	set SDF           86.0;
				set DR            83.0;
				set DP           116.0;
				set DE            13.0;
				set L             20.0;

#define lateral and gravity loads
            #gravity(kips)
                set GWR 		          [expr  ((($DR+$DE+$L)*($NX*$NZ)*($WB*$WB))/144000.0)+((($DP+$DE)*1.0*$NP*($WB*$WB))/144000.0)];
				set GWF                   [expr  ((($DF+$DE+$L)*$NX*$NZ*($WB*$WB))/144000.0)]; 
				set RoofGLoadPDeltaPier   [expr  $GWR*(($NZ-1.0)/(2.0*$NZ))]; 
				set RoofGLoadPier1and5    [expr  $GWR*(1.0/(2.0*$NX*2.0*$NZ))];
				set RoofGLoadPier2to4     [expr  $GWR*(1.0/(1.0*$NX*2.0*$NZ))];
				set FloorGLoadPDeltaPier  [expr  $GWF*(($NZ-1.0)/(2.0*$NZ))]; 
				set FloorGLoadPier1and5   [expr  $GWF*(1.0/(2.0*$NX*2.0*$NZ))];
				set FloorGLoadPier2to4    [expr  $GWF*(1.0/(1.0*$NX*2.0*$NZ))];
			#lateral(kips)
			    set SWR                   [expr  ((($DR+$DE)*($NX*$NZ)*($WB*$WB))/144000.0)+((($DP+$DE)*1.0*$NP*($WB*$WB))/144000.0)];
			    set SWF                   [expr  ((($SDF+$DE)*$NX*$NZ*($WB*$WB))/144000.0)];  
				set TSW                   [expr  $SWR+(2.0*$SWF)];
				set SLR                   [expr  (($SWR*($YRoof*$YRoof))/(($SWR*($YRoof*$YRoof))+($SWF*($YFloor3*$YFloor3))+($SWF*($YFloor2*$YFloor2))))*$TSW];
				set SLF3                  [expr  (($SWF*($YFloor3*$YFloor3))/(($SWR*($YRoof*$YRoof))+($SWF*($YFloor3*$YFloor3))+($SWF*($YFloor2*$YFloor2))))*$TSW];
				set SLF2                  [expr  (($SWF*($YFloor2*$YFloor2))/(($SWR*($YRoof*$YRoof))+($SWF*($YFloor3*$YFloor3))+($SWF*($YFloor2*$YFloor2))))*$TSW];
				set RoofLLoadPier1and5    [expr  ($SLR/2.0)*(1.0/(2.0*$NX))];
				set RoofLLoadPier2to4     [expr  ($SLR/2.0)*(1.0/(1.0*$NX))];
				set Floor3LLoadPier1and5  [expr  ($SLF3/2.0)*(1.0/(2.0*$NX))]; 
				set Floor3LLoadPier2to4   [expr  ($SLF3/2.0)*(1.0/(1.0*$NX))];
				set Floor2LLoadPier1and5  [expr  ($SLF2/2.0)*(1.0/(2.0*$NX))];
				set Floor2LLoadPier2to4   [expr  ($SLF2/2.0)*(1.0/(1.0*$NX))];
				
	puts "Frame Seismic Weight is [expr $TSW/2] kips"			
				
#step3
#define material properties & section properties
            #material
                set Ec       23200.0;
				set Eb       29000.0;
				set Fyc         50.0;
				set Fyb         36.0;
				set Ryc          1.1;
				set Ryb          1.5;
			#section(A(in^2);I(in^4);z(in^3);
			    #c(W14X257)
                set AExteriorColumns              75.6;
				set IExteriorColumns            3400.0;
				set ZExteriorColumns             487.0;
				#c(W14X311)
				set AInteriorColumns              91.4;
				set IInteriorColumns            4330.0;
				set ZInteriorColumns             603.0;
				#B2(W33X118)
				set AFloor2Beams                  34.7;
				set IFloor2Beams                5900.0;
				set ZFloor2Beams                 415.0;
				#B3(W30X99)
				set AFloor3Beams                  29.1;
				set IFloor3Beams                3990.0;
				set ZFloor3Beams                 312.0;
				#BR(W27X94)
				set ARoofBeams                    27.7;
				set IRoofBeams                  3270.0;
				set ZRoofBeams                   278.0;
				
			#rigid element
			    set Arigid                    100000.0;
				set Erigid                     10000.0;
				set Irigid                 100000000.0;
				
				set Ezero       0.00000000000000000001;
#step4:
#define stiffness of elemnts:
                 set a           10.0;  
                 set b           13.0;
                 set c           0.60;
                 set n           10.0; 
                 set McMy        1.03;
            #Assign columns 
                set P1A                            $AExteriorColumns;
				set P1E                                          $Ec;
				set P1I      [expr  (($n+1.0)/$n)*$IExteriorColumns];
				set P2to4A                         $AInteriorColumns;
				set P2to4E                                       $Ec;
				set P2to4I   [expr  (($n+1.0)/$n)*$IInteriorColumns];
				set P5A                            $AExteriorColumns;
				set P5E                                          $Ec;
				set P5I                            $IExteriorColumns;
				set PDA                                      $Arigid;
				set PDE                                      $Erigid;
				set PDI                                      $Irigid;
			#Assign Beams & Trusses
            set F2B1to3A                         $AFloor2Beams;  
	        set F2B1to3E                                   $Eb;  
	        set F2B1to3I   [expr  (($n+1.0)/$n)*$IFloor2Beams];  
		  
	        set F3B1to3A                         $AFloor3Beams;  
	        set F3B1to3E                                   $Eb;  
	        set F3B1to3I   [expr  (($n+1.0)/$n)*$IFloor3Beams];  
		 
	        set FRB1to3A                           $ARoofBeams;  
	        set FRB1to3E                                   $Eb;  
	        set FRB1to3I     [expr  (($n+1.0)/$n)*$IRoofBeams];  
	    
	        set F2B4A                            $AFloor2Beams;  
	        set F2B4E                                      $Eb;  
	        set F2B4I                            $IFloor2Beams;  
		                               
	        set F3B4A                            $AFloor3Beams;  
	        set F3B4E                                      $Eb;  
	        set F3B4I                            $IFloor3Beams;  
		                                  
	        set FRB4A                              $ARoofBeams;  
	        set FRB4E                                      $Eb;  
	        set FRB4I                              $IRoofBeams;  
	    
	        set F2B5A                                  $Arigid;  
	        set F2B5E                                  $Erigid;  
		                                
	        set F3B5A                                  $Arigid;  
	        set F3B5E                                  $Erigid;  
		 		                          
	        set FRB5A                                  $Arigid;  
	        set FRB5E                                  $Erigid; 	
#define & assign springs
          #c1
          set P1SMy                                              [expr  $Ryc*$Fyc*$ZExteriorColumns]; 
	      set P1SK                                               [expr  ($n+1.0)*((6.0*$Ec*$IExteriorColumns)/$HS)]; 
	      set P1STetap                                           [expr  $a*($n+1.0)*($P1SMy/$P1SK)];  
	      set P1STetapc                                          [expr  1.0*($n+1.0)*($P1SMy/$P1SK)];  
	      set P1STetau                                           [expr  $b*($n+1.0)*($P1SMy/$P1SK)];  
	      set P1Sk                                                $c;            
	      set P1Salpha                                           [expr  (($McMy-1.0)*$P1SMy*$HS)/((($n+1.0)*6.0*$Ec*$IExteriorColumns*$P1STetap)-($n*($McMy-1.0)*$P1SMy*$HS))];       
	       #c2-4             
		  set P2to4SMy                                           [expr  $Ryc*$Fyc*$ZInteriorColumns];  
	      set P2to4SK                                            [expr  ($n+1.0)*((6.0*$Ec*$IInteriorColumns)/$HS)];  
	      set P2to4STetap                                        [expr  $a*($n+1.0)*($P2to4SMy/$P2to4SK)];  
	      set P2to4STetapc                                       [expr  1.0*($n+1.0)*($P2to4SMy/$P2to4SK)];  
	      set P2to4STetau                                        [expr  $b*($n+1.0)*($P2to4SMy/$P2to4SK)];  
	      set P2to4Sk                                             $c;         
	      set P2to4Salpha                                        [expr  (($McMy-1.0)*$P2to4SMy*$HS)/((($n+1.0)*6.0*$Ec*$IInteriorColumns*$P2to4STetap)-($n*($McMy-1.0)*$P2to4SMy*$HS))];       	  
	      #c5     
		  set P5SE                                                $Ezero; 
	      #p-delta                                                                                                  
		  set PDSE                                                $Ezero;
		  
		#  spring use in beam
		      #beam f2
            set F2B1to3SMy                                                                                               [expr  $Ryb*$Fyb*$ZFloor2Beams];  
	        set F2B1to3SK                                                                                 [expr  ($n+1.0)*((6.0*$Eb*$IFloor2Beams)/$WB)];  
	        set F2B1to3STetap                                                                               [expr  $a*($n+1.0)*($F2B1to3SMy/$F2B1to3SK)];  	
	        set F2B1to3STetapc                                                                             [expr  1.0*($n+1.0)*($F2B1to3SMy/$F2B1to3SK)];  
	        set F2B1to3STetau                                                                               [expr  $b*($n+1.0)*($F2B1to3SMy/$F2B1to3SK)];  
	        set F2B1to3Sk                                                                                                                             $c;           
	        set F2B1to3Salpha   [expr  (($McMy-1.0)*$F2B1to3SMy*$WB)/((($n+1.0)*6.0*$Ec*$IFloor2Beams*$F2B1to3STetap)-($n*($McMy-1.0)*$F2B1to3SMy*$WB))];      
		       #beam f3
		    set F3B1to3SMy                                                                                               [expr  $Ryb*$Fyb*$ZFloor3Beams]; 
	        set F3B1to3SK                                                                                 [expr  ($n+1.0)*((6.0*$Eb*$IFloor3Beams)/$WB)];  
	        set F3B1to3STetap                                                                               [expr  $a*($n+1.0)*($F3B1to3SMy/$F3B1to3SK)];  
	        set F3B1to3STetapc                                                                             [expr  1.0*($n+1.0)*($F3B1to3SMy/$F3B1to3SK)];  
	        set F3B1to3STetau                                                                               [expr  $b*($n+1.0)*($F3B1to3SMy/$F3B1to3SK)];  
	        set F3B1to3Sk                                                                                                                             $c;  
	        set F3B1to3Salpha   [expr  (($McMy-1.0)*$F3B1to3SMy*$WB)/((($n+1.0)*6.0*$Ec*$IFloor3Beams*$F3B1to3STetap)-($n*($McMy-1.0)*$F3B1to3SMy*$WB))];       
		       #beam roof
		    set FRB1to3SMy                                                                                                [expr  $Ryb*$Fyb*$ZRoofBeams];  
	        set FRB1to3SK                                                                                  [expr  ($n+1.0)*((6.0*$Eb*$IRoofBeams)/$WB)];  
	        set FRB1to3STetap                                                                              [expr  $a*($n+1.0)*($FRB1to3SMy/$FRB1to3SK)];  
	        set FRB1to3STetapc                                                                            [expr  1.0*($n+1.0)*($FRB1to3SMy/$FRB1to3SK)];  
	        set FRB1to3STetau                                                                              [expr  $b*($n+1.0)*($FRB1to3SMy/$FRB1to3SK)];  
	        set FRB1to3Sk                                                                                                                            $c;        
	        set FRB1to3Salpha    [expr  (($McMy-1.0)*$FRB1to3SMy*$WB)/((($n+1.0)*6.0*$Ec*$IRoofBeams*$FRB1to3STetap)-($n*($McMy-1.0)*$FRB1to3SMy*$WB))];  
			
	    
	      		 
		    set F2B4SE                                                                                                                           $Ezero;  
	     	                                                                                                                       
		    set F3B4SE                                                                                                                           $Ezero;   
	     	                                                                                                                           
		    set FRB4SE                                                                                                                           $Ezero;  	
#Define the Default Properties for Plastic Hinge Springs 			
	        set  LS  10000.0;  	  set  cS  1.0;		set  DN  1.0;				
            set  LK  10000.0;     set  cK  1.0;     set  DP  1.0;
            set  LA  10000.0;     set  cA  1.0;
            set  LD  10000.0;     set  cD  1.0;	
#step5
           set  GeomTransfTag  1;		         # The Transformer Tag is Saved in a Separate Variable to Make Member Definitions Easier.
		        geomTransf  Linear  $GeomTransfTag;  # for "P-Delta" Transformer, Just Change the "Linear" to "PDelta".	
#step6
#ِdefine nodes
			# Base Nodes
		  node  11  $XPier1         $YBase; 	
		  node  21  $XPier2         $YBase;
		  node  31  $XPier3         $YBase;
		  node  41  $XPier4         $YBase;
		  node  51  $XPier5         $YBase;
		  node  61  $XPDeltaPier    $YBase;
		# F2 Nodes
		  node  12  $XPier1       $YFloor2;
		  node  22  $XPier2       $YFloor2;
		  node  32  $XPier3       $YFloor2;
		  node  42  $XPier4       $YFloor2;
		  node  52  $XPier5       $YFloor2;
		  node  62  $XPDeltaPier  $YFloor2;
		# F3 Nodes
		  node  13  $XPier1       $YFloor3;
		  node  23  $XPier2       $YFloor3;
		  node  33  $XPier3       $YFloor3;
		  node  43  $XPier4       $YFloor3;
		  node  53  $XPier5       $YFloor3;
		  node  63  $XPDeltaPier  $YFloor3;
		# R Nodes
		  node  14  $XPier1         $YRoof;
		  node  24  $XPier2         $YRoof;
		  node  34  $XPier3         $YRoof;
		  node  44  $XPier4         $YRoof;
		  node  54  $XPier5         $YRoof;
		  node  64  $XPDeltaPier    $YRoof;
#step7
#define nodes condition of base      c1                          c2                      c3                 c4                    c5                p-delta(c6)
                                  fix  11  1  1  1;     fix  21  1  1  1;	    fix  31  1  1  1;	  fix  41  1  1  1;     fix  51  1  1  1;	  fix  61  1  1  1;
# Step8 
# Create Diaphragm
          equalDOF  12  22  1;     equalDOF  12  32  1;     equalDOF  12  42  1;     equalDOF  12  52  1;	  equalDOF  12  62  1;	# F2
		  equalDOF  13  23  1;     equalDOF  13  33  1;     equalDOF  13  43  1;     equalDOF  13  53  1;     equalDOF  13  63  1;	# F3
		  equalDOF  14  24  1;     equalDOF  14  34  1;     equalDOF  14  44  1;     equalDOF  14  54  1;     equalDOF  14  64  1;	#R	
#step9
#define nodes which needed for use springs	
	 
          node  117  $XPier1         $YBase; 		   	      node  146  $XPier1         $YRoof;
		  node  217  $XPier2         $YBase;		          node  246  $XPier2         $YRoof; 
		  node  317  $XPier3         $YBase;		   	      node  346  $XPier3         $YRoof;
		  node  417  $XPier4         $YBase;		   	      node  446  $XPier4         $YRoof;
		  node  517  $XPier5         $YBase;		   	      node  546  $XPier5         $YRoof;
		  node  617  $XPDeltaPier    $YBase;		   	      node  646  $XPDeltaPier    $YRoof;
			       
		  node  127  $XPier1       $YFloor2;		   	      node  126  $XPier1       $YFloor2;
		  node  227  $XPier2       $YFloor2;		   	      node  226  $XPier2       $YFloor2; 
		  node  327  $XPier3       $YFloor2;		   	      node  326  $XPier3       $YFloor2; 
		  node  427  $XPier4       $YFloor2;		   	      node  426  $XPier4       $YFloor2;
		  node  527  $XPier5       $YFloor2;		   	      node  526  $XPier5       $YFloor2;
		  node  627  $XPDeltaPier  $YFloor2;		   	      node  626  $XPDeltaPier  $YFloor2;
		
		  node  137  $XPier1       $YFloor3;		   	      node  136  $XPier1       $YFloor3;
		  node  237  $XPier2       $YFloor3;		   	      node  236  $XPier2       $YFloor3;
		  node  337  $XPier3       $YFloor3;		   	      node  336  $XPier3       $YFloor3; 
		  node  437  $XPier4       $YFloor3;		   	      node  436  $XPier4       $YFloor3;
		  node  537  $XPier5       $YFloor3;		   	      node  536  $XPier5       $YFloor3;
		  node  637  $XPDeltaPier  $YFloor3;		   	      node  636  $XPDeltaPier  $YFloor3;		
	   			
		  node  129  $XPier1       $YFloor2;		   	      node  528  $XPier5       $YFloor2;				
		  node  139  $XPier1       $YFloor3;		   	      node  538  $XPier5       $YFloor3;				
		  node  149  $XPier1         $YRoof;		   	      node  548  $XPier5         $YRoof;				
	    	    	
		  node  229  $XPier2       $YFloor2;		   	      node  228  $XPier2       $YFloor2;						
		  node  239  $XPier2       $YFloor3;		   	      node  238  $XPier2       $YFloor3;					
		  node  249  $XPier2         $YRoof;		   	      node  248  $XPier2         $YRoof;						
	        	
		  node  329  $XPier3       $YFloor2;		          node  328  $XPier3       $YFloor2;						
		  node  339  $XPier3       $YFloor3;		          node  338  $XPier3       $YFloor3;						
		  node  349  $XPier3         $YRoof;		          node  348  $XPier3         $YRoof;							
	      	
		  node  429  $XPier4       $YFloor2;		   	      node  428  $XPier4       $YFloor2;						
		  node  439  $XPier4       $YFloor3;		   	      node  438  $XPier4       $YFloor3;						
		  node  449  $XPier4         $YRoof;		   	      node  448  $XPier4         $YRoof;		 
 #step10
#define column element  
        # c1
	      element elasticBeamColumn  111  117  126   $P1A     $P1E     $P1I    $GeomTransfTag;  
		  element elasticBeamColumn  112  127  136   $P1A     $P1E     $P1I    $GeomTransfTag;  
	      element elasticBeamColumn  113  137  146   $P1A     $P1E     $P1I    $GeomTransfTag;  
	    # c2                                                              
	      element elasticBeamColumn  121  217  226  $P2to4A  $P2to4E  $P2to4I  $GeomTransfTag;  
		  element elasticBeamColumn  122  227  236  $P2to4A  $P2to4E  $P2to4I  $GeomTransfTag;  
	      element elasticBeamColumn  123  237  246  $P2to4A  $P2to4E  $P2to4I  $GeomTransfTag;  		  
	    # c3                                          
	      element elasticBeamColumn  131  317  326  $P2to4A  $P2to4E  $P2to4I  $GeomTransfTag;  
		  element elasticBeamColumn  132  327  336  $P2to4A  $P2to4E  $P2to4I  $GeomTransfTag;  
	      element elasticBeamColumn  133  337  346  $P2to4A  $P2to4E  $P2to4I  $GeomTransfTag; 	
	    # c4                                   
	      element elasticBeamColumn  141  417  426  $P2to4A  $P2to4E  $P2to4I  $GeomTransfTag;  
		  element elasticBeamColumn  142  427  436  $P2to4A  $P2to4E  $P2to4I  $GeomTransfTag;  
	      element elasticBeamColumn  143  437  446  $P2to4A  $P2to4E  $P2to4I  $GeomTransfTag;  			  
	    # c5                                                              
	      element elasticBeamColumn  151  517  526   $P5A     $P5E     $P5I    $GeomTransfTag;  
		  element elasticBeamColumn  152  527  536   $P5A     $P5E     $P5I    $GeomTransfTag;  
	      element elasticBeamColumn  153  537  546   $P5A     $P5E     $P5I    $GeomTransfTag;
		  
		  # P-Delta  Columns  
	      element elasticBeamColumn  261  617  626   $PDA     $PDE     $PDI    $GeomTransfTag;  
		  element elasticBeamColumn  262  627  636   $PDA     $PDE     $PDI    $GeomTransfTag;  
	      element elasticBeamColumn  263  637  646   $PDA     $PDE     $PDI    $GeomTransfTag;
#step11
#define beam element
       # Bay 1
	      element elasticBeamColumn  312  129  228  $F2B1to3A  $F2B1to3E  $F2B1to3I  $GeomTransfTag; 
	      element elasticBeamColumn  313  139  238  $F3B1to3A  $F3B1to3E  $F3B1to3I  $GeomTransfTag;   
	      element elasticBeamColumn  314  149  248  $FRB1to3A  $FRB1to3E  $FRB1to3I  $GeomTransfTag;  
	    # Bay 2                             
	      element elasticBeamColumn  322  229  328  $F2B1to3A  $F2B1to3E  $F2B1to3I  $GeomTransfTag; 
	      element elasticBeamColumn  323  239  338  $F3B1to3A  $F3B1to3E  $F3B1to3I  $GeomTransfTag; 
	      element elasticBeamColumn  324  249  348  $FRB1to3A  $FRB1to3E  $FRB1to3I  $GeomTransfTag;  
	    # Bay 3                                   
	      element elasticBeamColumn  332  329  428  $F2B1to3A  $F2B1to3E  $F2B1to3I  $GeomTransfTag;  
	      element elasticBeamColumn  333  339  438  $F3B1to3A  $F3B1to3E  $F3B1to3I  $GeomTransfTag;  
	      element elasticBeamColumn  334  349  448  $FRB1to3A  $FRB1to3E  $FRB1to3I  $GeomTransfTag;  
	    # Bay 4                                                               
	      element elasticBeamColumn  342  429  528   $F2B4A     $F2B4E     $F2B4I    $GeomTransfTag;  
	      element elasticBeamColumn  343  439  538   $F3B4A     $F3B4E     $F3B4I    $GeomTransfTag;   
	      element elasticBeamColumn  344  449  548   $FRB4A     $FRB4E     $FRB4I    $GeomTransfTag;
#step12
        # Bay 5  
		  uniaxialMaterial Elastic 452 $F2B5E;  element truss 452 52 62 $F2B5A 452;  
	      uniaxialMaterial Elastic 453 $F3B5E;  element truss 453 53 63 $F3B5A 453;    
		  uniaxialMaterial Elastic 454 $FRB5E;  element truss 454 54 64 $FRB5A 454;
#step13		  
# Pier 1 Springs
		  uniaxialMaterial Bilin 5117 $P1SK $P1Salpha $P1Salpha $P1SMy [expr -$P1SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P1STetap $P1STetap $P1STetapc $P1STetapc $P1Sk $P1Sk $P1STetau $P1STetau $DP $DN;
		  uniaxialMaterial Bilin 5126 $P1SK $P1Salpha $P1Salpha $P1SMy [expr -$P1SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P1STetap $P1STetap $P1STetapc $P1STetapc $P1Sk $P1Sk $P1STetau $P1STetau $DP $DN;
		  uniaxialMaterial Bilin 5127 $P1SK $P1Salpha $P1Salpha $P1SMy [expr -$P1SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P1STetap $P1STetap $P1STetapc $P1STetapc $P1Sk $P1Sk $P1STetau $P1STetau $DP $DN;
		  uniaxialMaterial Bilin 5136 $P1SK $P1Salpha $P1Salpha $P1SMy [expr -$P1SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P1STetap $P1STetap $P1STetapc $P1STetapc $P1Sk $P1Sk $P1STetau $P1STetau $DP $DN;
		  uniaxialMaterial Bilin 5137 $P1SK $P1Salpha $P1Salpha $P1SMy [expr -$P1SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P1STetap $P1STetap $P1STetapc $P1STetapc $P1Sk $P1Sk $P1STetau $P1STetau $DP $DN;
		  uniaxialMaterial Bilin 5146 $P1SK $P1Salpha $P1Salpha $P1SMy [expr -$P1SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P1STetap $P1STetap $P1STetapc $P1STetapc $P1Sk $P1Sk $P1STetau $P1STetau $DP $DN;
		  element zeroLength 5117 11 117 -mat 5117 -dir 6;  equalDOF 11 117 1 2;  
		  element zeroLength 5126 12 126 -mat 5126 -dir 6;  equalDOF 12 126 1 2;  
		  element zeroLength 5127 12 127 -mat 5127 -dir 6;  equalDOF 12 127 1 2;  	
		  element zeroLength 5136 13 136 -mat 5136 -dir 6;  equalDOF 13 136 1 2;  
		  element zeroLength 5137 13 137 -mat 5137 -dir 6;  equalDOF 13 137 1 2;  
		  element zeroLength 5146 14 146 -mat 5146 -dir 6;  equalDOF 14 146 1 2;  
		# Pier 2 Springs
		  uniaxialMaterial Bilin 5217 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5226 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5227 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5236 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5237 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5246 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  element zeroLength 5217 21 217 -mat 5217 -dir 6;  equalDOF 21 217 1 2;  
		  element zeroLength 5226 22 226 -mat 5226 -dir 6;  equalDOF 22 226 1 2;  
		  element zeroLength 5227 22 227 -mat 5227 -dir 6;  equalDOF 22 227 1 2;  	
		  element zeroLength 5236 23 236 -mat 5236 -dir 6;  equalDOF 23 236 1 2;  
		  element zeroLength 5237 23 237 -mat 5237 -dir 6;  equalDOF 23 237 1 2;  
		  element zeroLength 5246 24 246 -mat 5246 -dir 6;  equalDOF 24 246 1 2;  
		# Pier 3 Springs
		  uniaxialMaterial Bilin 5317 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5326 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5327 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5336 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5337 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5346 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  element zeroLength 5317 31 317 -mat 5317 -dir 6;  equalDOF 31 317 1 2;  
		  element zeroLength 5326 32 326 -mat 5326 -dir 6;  equalDOF 32 326 1 2;  
		  element zeroLength 5327 32 327 -mat 5327 -dir 6;  equalDOF 32 327 1 2;  
		  element zeroLength 5336 33 336 -mat 5336 -dir 6;  equalDOF 33 336 1 2;  
		  element zeroLength 5337 33 337 -mat 5337 -dir 6;  equalDOF 33 337 1 2;  
		  element zeroLength 5346 34 346 -mat 5346 -dir 6;  equalDOF 34 346 1 2;  
		# Pier 4 Springs                                                        
		  uniaxialMaterial Bilin 5417 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5426 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5427 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5436 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5437 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5446 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  element zeroLength 5417 41 417 -mat 5417 -dir 6;  equalDOF 41 417 1 2;  
		  element zeroLength 5426 42 426 -mat 5426 -dir 6;  equalDOF 42 426 1 2;  
		  element zeroLength 5427 42 427 -mat 5427 -dir 6;  equalDOF 42 427 1 2;  	
		  element zeroLength 5436 43 436 -mat 5436 -dir 6;  equalDOF 43 436 1 2;  
		  element zeroLength 5437 43 437 -mat 5437 -dir 6;  equalDOF 43 437 1 2;  
		  element zeroLength 5446 44 446 -mat 5446 -dir 6;  equalDOF 44 446 1 2;  		

	# Step14
		#  c5 Springs
		  uniaxialMaterial Elastic 5517 $P5SE;  element zeroLength 5517 51 517 -mat 5517 -dir 6;  equalDOF 51 517 1 2;  
		  uniaxialMaterial Elastic 5526 $P5SE;  element zeroLength 5526 52 526 -mat 5526 -dir 6;  equalDOF 52 526 1 2;  
		  uniaxialMaterial Elastic 5527 $P5SE;  element zeroLength 5527 52 527 -mat 5527 -dir 6;  equalDOF 52 527 1 2;  
		  uniaxialMaterial Elastic 5536 $P5SE;  element zeroLength 5536 53 536 -mat 5536 -dir 6;  equalDOF 53 536 1 2;  
		  uniaxialMaterial Elastic 5537 $P5SE;  element zeroLength 5537 53 537 -mat 5537 -dir 6;  equalDOF 53 537 1 2;  
		  uniaxialMaterial Elastic 5546 $P5SE;  element zeroLength 5546 54 546 -mat 5546 -dir 6;  equalDOF 54 546 1 2;  
		# P-Delta 
		  uniaxialMaterial Elastic 5617 $PDSE;  element zeroLength 5617 61 617 -mat 5617 -dir 6;  equalDOF 61 617 1 2;  
		  uniaxialMaterial Elastic 5626 $PDSE;  element zeroLength 5626 62 626 -mat 5626 -dir 6;  equalDOF 62 626 1 2;  
		  uniaxialMaterial Elastic 5627 $PDSE;  element zeroLength 5627 62 627 -mat 5627 -dir 6;  equalDOF 62 627 1 2; 
		  uniaxialMaterial Elastic 5636 $PDSE;  element zeroLength 5636 63 636 -mat 5636 -dir 6;  equalDOF 63 636 1 2;  
		  uniaxialMaterial Elastic 5637 $PDSE;  element zeroLength 5637 63 637 -mat 5637 -dir 6;  equalDOF 63 637 1 2;  
		  uniaxialMaterial Elastic 5646 $PDSE;  element zeroLength 5646 64 646 -mat 5646 -dir 6;  equalDOF 64 646 1 2;  
# -------------------------------------------------------------------------------------------------------------------------------------------
	# Step15 Define Bays	
		# Bay 1 Springs
	 	  uniaxialMaterial Bilin 6129 $F2B1to3SK $F2B1to3Salpha $F2B1to3Salpha $F2B1to3SMy [expr -$F2B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F2B1to3STetap $F2B1to3STetap $F2B1to3STetapc $F2B1to3STetapc $F2B1to3Sk $F2B1to3Sk $F2B1to3STetau $F2B1to3STetau $DP $DN;
	 	  uniaxialMaterial Bilin 6228 $F2B1to3SK $F2B1to3Salpha $F2B1to3Salpha $F2B1to3SMy [expr -$F2B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F2B1to3STetap $F2B1to3STetap $F2B1to3STetapc $F2B1to3STetapc $F2B1to3Sk $F2B1to3Sk $F2B1to3STetau $F2B1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6139 $F3B1to3SK $F3B1to3Salpha $F3B1to3Salpha $F3B1to3SMy [expr -$F3B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F3B1to3STetap $F3B1to3STetap $F3B1to3STetapc $F3B1to3STetapc $F3B1to3Sk $F3B1to3Sk $F3B1to3STetau $F3B1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6238 $F3B1to3SK $F3B1to3Salpha $F3B1to3Salpha $F3B1to3SMy [expr -$F3B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F3B1to3STetap $F3B1to3STetap $F3B1to3STetapc $F3B1to3STetapc $F3B1to3Sk $F3B1to3Sk $F3B1to3STetau $F3B1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6149 $FRB1to3SK $FRB1to3Salpha $FRB1to3Salpha $FRB1to3SMy [expr -$FRB1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $FRB1to3STetap $FRB1to3STetap $FRB1to3STetapc $FRB1to3STetapc $FRB1to3Sk $FRB1to3Sk $FRB1to3STetau $FRB1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6248 $FRB1to3SK $FRB1to3Salpha $FRB1to3Salpha $FRB1to3SMy [expr -$FRB1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $FRB1to3STetap $FRB1to3STetap $FRB1to3STetapc $FRB1to3STetapc $FRB1to3Sk $FRB1to3Sk $FRB1to3STetau $FRB1to3STetau $DP $DN;
	 	  element zeroLength 6129 12 129 -mat 6129 -dir 6;  equalDOF 12 129 1 2;     
	 	  element zeroLength 6228 22 228 -mat 6228 -dir 6;  equalDOF 22 228 1 2;         
		  element zeroLength 6139 13 139 -mat 6139 -dir 6;  equalDOF 13 139 1 2;         
		  element zeroLength 6238 23 238 -mat 6238 -dir 6;  equalDOF 23 238 1 2;        
		  element zeroLength 6149 14 149 -mat 6149 -dir 6;  equalDOF 14 149 1 2;        
		  element zeroLength 6248 24 248 -mat 6248 -dir 6;  equalDOF 24 248 1 2;        
		# Bay 2 Springs                                                              
	 	  uniaxialMaterial Bilin 6229 $F2B1to3SK $F2B1to3Salpha $F2B1to3Salpha $F2B1to3SMy [expr -$F2B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F2B1to3STetap $F2B1to3STetap $F2B1to3STetapc $F2B1to3STetapc $F2B1to3Sk $F2B1to3Sk $F2B1to3STetau $F2B1to3STetau $DP $DN;
	 	  uniaxialMaterial Bilin 6328 $F2B1to3SK $F2B1to3Salpha $F2B1to3Salpha $F2B1to3SMy [expr -$F2B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F2B1to3STetap $F2B1to3STetap $F2B1to3STetapc $F2B1to3STetapc $F2B1to3Sk $F2B1to3Sk $F2B1to3STetau $F2B1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6239 $F3B1to3SK $F3B1to3Salpha $F3B1to3Salpha $F3B1to3SMy [expr -$F3B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F3B1to3STetap $F3B1to3STetap $F3B1to3STetapc $F3B1to3STetapc $F3B1to3Sk $F3B1to3Sk $F3B1to3STetau $F3B1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6338 $F3B1to3SK $F3B1to3Salpha $F3B1to3Salpha $F3B1to3SMy [expr -$F3B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F3B1to3STetap $F3B1to3STetap $F3B1to3STetapc $F3B1to3STetapc $F3B1to3Sk $F3B1to3Sk $F3B1to3STetau $F3B1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6249 $FRB1to3SK $FRB1to3Salpha $FRB1to3Salpha $FRB1to3SMy [expr -$FRB1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $FRB1to3STetap $FRB1to3STetap $FRB1to3STetapc $FRB1to3STetapc $FRB1to3Sk $FRB1to3Sk $FRB1to3STetau $FRB1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6348 $FRB1to3SK $FRB1to3Salpha $FRB1to3Salpha $FRB1to3SMy [expr -$FRB1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $FRB1to3STetap $FRB1to3STetap $FRB1to3STetapc $FRB1to3STetapc $FRB1to3Sk $FRB1to3Sk $FRB1to3STetau $FRB1to3STetau $DP $DN;
	 	  element zeroLength 6229 22 229 -mat 6229 -dir 6;  equalDOF 22 229 1 2;   
	 	  element zeroLength 6328 32 328 -mat 6328 -dir 6;  equalDOF 32 328 1 2;    
		  element zeroLength 6239 23 239 -mat 6239 -dir 6;  equalDOF 23 239 1 2; 
		  element zeroLength 6338 33 338 -mat 6338 -dir 6;  equalDOF 33 338 1 2;  
		  element zeroLength 6249 24 249 -mat 6249 -dir 6;  equalDOF 24 249 1 2;     
		  element zeroLength 6348 34 348 -mat 6348 -dir 6;  equalDOF 34 348 1 2;  
		# Bay 3 Springs                                                         
	 	  uniaxialMaterial Bilin 6329 $F2B1to3SK $F2B1to3Salpha $F2B1to3Salpha $F2B1to3SMy [expr -$F2B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F2B1to3STetap $F2B1to3STetap $F2B1to3STetapc $F2B1to3STetapc $F2B1to3Sk $F2B1to3Sk $F2B1to3STetau $F2B1to3STetau $DP $DN;
	 	  uniaxialMaterial Bilin 6428 $F2B1to3SK $F2B1to3Salpha $F2B1to3Salpha $F2B1to3SMy [expr -$F2B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F2B1to3STetap $F2B1to3STetap $F2B1to3STetapc $F2B1to3STetapc $F2B1to3Sk $F2B1to3Sk $F2B1to3STetau $F2B1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6339 $F3B1to3SK $F3B1to3Salpha $F3B1to3Salpha $F3B1to3SMy [expr -$F3B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F3B1to3STetap $F3B1to3STetap $F3B1to3STetapc $F3B1to3STetapc $F3B1to3Sk $F3B1to3Sk $F3B1to3STetau $F3B1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6438 $F3B1to3SK $F3B1to3Salpha $F3B1to3Salpha $F3B1to3SMy [expr -$F3B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F3B1to3STetap $F3B1to3STetap $F3B1to3STetapc $F3B1to3STetapc $F3B1to3Sk $F3B1to3Sk $F3B1to3STetau $F3B1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6349 $FRB1to3SK $FRB1to3Salpha $FRB1to3Salpha $FRB1to3SMy [expr -$FRB1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $FRB1to3STetap $FRB1to3STetap $FRB1to3STetapc $FRB1to3STetapc $FRB1to3Sk $FRB1to3Sk $FRB1to3STetau $FRB1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6448 $FRB1to3SK $FRB1to3Salpha $FRB1to3Salpha $FRB1to3SMy [expr -$FRB1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $FRB1to3STetap $FRB1to3STetap $FRB1to3STetapc $FRB1to3STetapc $FRB1to3Sk $FRB1to3Sk $FRB1to3STetau $FRB1to3STetau $DP $DN;
	 	  element zeroLength 6329 32 329 -mat 6329 -dir 6;  equalDOF 32 329 1 2;    
	 	  element zeroLength 6428 42 428 -mat 6428 -dir 6;  equalDOF 42 428 1 2;    
		  element zeroLength 6339 33 339 -mat 6339 -dir 6;  equalDOF 33 339 1 2;   
		  element zeroLength 6438 43 438 -mat 6438 -dir 6;  equalDOF 43 438 1 2;   
		  element zeroLength 6349 34 349 -mat 6349 -dir 6;  equalDOF 34 349 1 2;    
		  element zeroLength 6448 44 448 -mat 6448 -dir 6;  equalDOF 44 448 1 2;   

	# Step16 
	    # Bay 4 Springs
		  uniaxialMaterial Elastic 6429 $F2B4SE;  element zeroLength 6429 42 429 -mat 6429 -dir 6;  equalDOF 42 429 1 2;  # Floor 2 Left Spring  
		  uniaxialMaterial Elastic 6528 $F2B4SE;  element zeroLength 6528 52 528 -mat 6528 -dir 6;  equalDOF 52 528 1 2;  # Floor 2 Right Spring  
		  uniaxialMaterial Elastic 6439 $F3B4SE;  element zeroLength 6439 43 439 -mat 6439 -dir 6;  equalDOF 43 439 1 2;  # Floor 3 Left Spring 
		  uniaxialMaterial Elastic 6538 $F3B4SE;  element zeroLength 6538 53 538 -mat 6538 -dir 6;  equalDOF 53 538 1 2;  # Floor 3 Right Spring 
		  uniaxialMaterial Elastic 6449 $FRB4SE;  element zeroLength 6449 44 449 -mat 6449 -dir 6;  equalDOF 44 449 1 2;  # Roof Left Spring   
		  uniaxialMaterial Elastic 6548 $FRB4SE;  element zeroLength 6548 54 548 -mat 6548 -dir 6;  equalDOF 54 548 1 2;  # Roof Right Spring 
	
	# Optional: Create a Group Consisted of the Springs Defined in the Actual Piers and Bays 
	                   # Pier 1 Springs                 # Pier 2 Springs                 # Pier 3 Springs                 # Pier 4 Springs                 # Pier 5 Springs                 # Floor 2 Springs                          # Floor 3 Springs                          # Roof Springs
        region 1 -ele    5117 5126 5127 5136 5137 5146    5217 5226 5227 5236 5237 5246    5317 5326 5327 5336 5337 5346    5417 5426 5427 5436 5437 5446    5517 5526 5527 5536 5537 5546    6129 6228 6229 6328 6329 6428 6429 6528    6139 6238 6239 6338 6339 6438 6439 6538    6149 6248 6249 6348 6349 6448 6449 6548 
# Step17  Apply the Gravitational Loads
	  
	  pattern Plain 101 Constant {
	    # Downward Point Loads on Actual Nodes
	    #                    load  nodeID  $Fx[kips]  $Fy[kips]  $Mz[kips-in]
		  # Pier 1 Nodes		
			load  12  0.0  [expr -$FloorGLoadPier1and5]   0.0;  # Floor 2 #kips
			load  13  0.0  [expr -$FloorGLoadPier1and5]   0.0;  # Floor 3 #kips		
			load  14  0.0  [expr -$RoofGLoadPier1and5]    0.0;  # Roof    #kips
		  # Pier 2 Nodes		                                           
		    load  22  0.0  [expr -$FloorGLoadPier2to4]    0.0;  # Floor 2 #kips		
		    load  23  0.0  [expr -$FloorGLoadPier2to4]    0.0;  # Floor 3 #kips		
		    load  24  0.0  [expr -$RoofGLoadPier2to4]     0.0;  # Roof	  #kips			  
		  # Pier 3 Nodes	                                                 
			load  32  0.0  [expr -$FloorGLoadPier2to4]    0.0;  # Floor 2 #kips		
			load  33  0.0  [expr -$FloorGLoadPier2to4]    0.0;  # Floor 3 #kips		
			load  34  0.0  [expr -$RoofGLoadPier2to4]     0.0;  # Roof	  #kips	
		  # Pier 4 Nodes	                                                 
			load  42  0.0  [expr -$FloorGLoadPier2to4]    0.0;  # Floor 2 #kips		
			load  43  0.0  [expr -$FloorGLoadPier2to4]    0.0;  # Floor 3 #kips		
			load  44  0.0  [expr -$RoofGLoadPier2to4]     0.0;  # Roof	  #kips	
		  # Pier 5 Nodes	                                                 
			load  52  0.0  [expr -$FloorGLoadPier1and5]   0.0;  # Floor 2 #kips		
			load  53  0.0  [expr -$FloorGLoadPier1and5]   0.0;  # Floor 3 #kips
			load  54  0.0  [expr -$RoofGLoadPier1and5]    0.0;  # Roof	  #kips		
		  # P-Delta Pier Nodes                                              
			load  62  0.0  [expr -$FloorGLoadPDeltaPier]  0.0;  # Floor 2 #kips
			load  63  0.0  [expr -$FloorGLoadPDeltaPier]  0.0;  # Floor 3 #kips
			load  64  0.0  [expr -$RoofGLoadPDeltaPier]   0.0;  # Roof    #kips
	  }

	# Step 17 				
	  constraints Plain;						
	  numberer RCM;							
	  system BandGeneral;						
	  test NormDispIncr 1.0e-6 600;				
	  algorithm Newton;								
	  integrator LoadControl 0.01;		
	  analysis Static;					
	  analyze 100;
	
	# Step 18 
	  loadConst -time 0.0
	#step19
	             recorder  Drift  -file  LinearFloor4DriftFromBase.txt    -iNode                11               -jNode              14                -dof               1               -perpDirn                 2;
		         recorder  Drift  -file  LinearFloor2DriftFromFloor1.txt  -iNode                11               -jNode              12                -dof               1               -perpDirn                 2;
		         recorder  Drift  -file  LinearFloor3DriftFromFloor2.txt  -iNode                12               -jNode              13                -dof               1               -perpDirn                 2;
		         recorder  Drift  -file  LinearFloor4DriftFromFloor3.txt  -iNode                13               -jNode              14                -dof               1               -perpDirn                 2;

	  #          recorder  Node   -file    Output_File_Name     -node/region          Node/Region#          -dof  Target_DoFs  Type
		         recorder  Node   -file  LinearFloor1Shear.txt  -node         117  217  317  417  517  617  -dof       1       reaction;
		         recorder  Node   -file  LinearFloor2Shear.txt  -node         127  227  327  427  527  627  -dof       1       reaction;
		         recorder  Node   -file  LinearFloor3Shear.txt  -node         137  237  337  437  537  637  -dof       1       reaction;

	  #          recorder  Element  -file    Output_File_Name         -ele/region  Element/Region#  Type
		         recorder  Element  -file  LinearSpringsRotation.txt  -region            1          deformation;
	# Step20  Assign the Lateral Loads
	  
	  pattern Plain 200 Linear {
	    # Downward Point Loads on Actual Nodes
	    # Command: load  nodeID  $Fx[kips]  $Fy[kips]  $Mz[kips-in]
		  # Floor 2 Loads
		    load  12  $Floor2LLoadPier1and5  0.0  0.0;  # Pier 1 #kips
		    load  22  $Floor2LLoadPier2to4   0.0  0.0;  # Pier 2 #kips
		    load  32  $Floor2LLoadPier2to4   0.0  0.0;  # Pier 3 #kips
		    load  42  $Floor2LLoadPier2to4   0.0  0.0;  # Pier 4 #kips
		    load  52  $Floor2LLoadPier1and5  0.0  0.0;  # Pier 5 #kips
		  # Floor 3 Loads
		    load  13  $Floor3LLoadPier1and5  0.0  0.0;  # Pier 1 #kips
		    load  23  $Floor3LLoadPier2to4   0.0  0.0;  # Pier 2 #kips
		    load  33  $Floor3LLoadPier2to4   0.0  0.0;  # Pier 3 #kips
		    load  43  $Floor3LLoadPier2to4   0.0  0.0;  # Pier 4 #kips
		    load  53  $Floor3LLoadPier1and5  0.0  0.0;  # Pier 5 #kips			
		  # Roof Loads
		    load  14  $RoofLLoadPier1and5    0.0  0.0;  # Pier 1 #kips
		    load  24  $RoofLLoadPier2to4     0.0  0.0;  # Pier 2 #kips
		    load  34  $RoofLLoadPier2to4     0.0  0.0;  # Pier 3 #kips
		    load  44  $RoofLLoadPier2to4     0.0  0.0;  # Pier 4 #kips
		    load  54  $RoofLLoadPier1and5    0.0  0.0;  # Pier 5 #kips	
# Displacement Checker Parameters Parameters
	  set IDctrlNode                         14;  # Node Where Displacement is Read for Displacement Control
	  set IDctrlDOF                           1;  # Degree of Freedom Where Displacement is Read for Displacement Control (1 = X-Displacement Displacement)
	  set TargetDrift                      0.05;  # Maximum Preferred Roof Drift  
	  set Dincr                           0.001;  # Displacement Increment		
	  set Dmax   [expr $TargetDrift*$HBuilding];  # Maximum Displacement of Pushover
	  set Nsteps       [expr int($Dmax/$Dincr)];  # Number of Pushover Analysis Steps
#Analysis
	  constraints Plain;					                          
	  numberer RCM;						                                
	  system BandGeneral;				   	                            
	  test NormUnbalance 1.0e-5 1000;		                           
	  algorithm Newton;					                                
	  integrator DisplacementControl  $IDctrlNode  $IDctrlDOF  $Dincr;  
	  analysis Static;					                                
	  set ok [analyze $Nsteps];			
	
		
		  
		  
		  
		  
		  
				
				



			
				
				
				