# Units: kips, inches, seconds
#############################################################################################################################################
#                                                            GENERAL DEFINITIONS                                                            #
#############################################################################################################################################
	# Set Up & Source Definition									  
	  wipe all;						     # clear memory of past model definitions
	  model BasicBuilder -ndm 2 -ndf 3;  # Define the model builder, ndm = #dimension, ndf = #dofs
#############################################################################################################################################
#                                                     GEOMETRY INFORMATION PRE-DEFINITION                                                   #
#############################################################################################################################################
	# Step 1 - Part 01 - Define Structure Geometry Parameters (See Page 6 of "Session 05.pdf" File)
	  set NS                           3.0;  # Number of Stories
	  set NX                           4.0;  # Number of Frame Bays (Exclude the Bay Between Pier 5 and P-delta Pier)
	  set NZ                           6.0;  # Number of Structure Bays Perpendicular to Frame
	  set NP                           2.0;  # Number of Structure Bays Under Penthouse	
	  set WB              [expr 30.0*12.0];  # Bay widths    #inches
	  set HS              [expr 13.0*12.0];  # Story Heights #inches
	  set HBuilding         [expr $NS*$HS];  # Height of Building
# -------------------------------------------------------------------------------------------------------------------------------------------		
	# Step 1 - Part 02 - Calculate Pier Positions and Floor Elevations (See Page 6 of "Session 05.pdf" File)
	  set XPier1                       0.0;  # X Position of Pier 1       #inches
	  set XPier2        [expr $XPier1+$WB];  # X Position of Pier 2       #inches
	  set XPier3        [expr $XPier2+$WB];  # X Position of Pier 3       #inches
	  set XPier4        [expr $XPier3+$WB];  # X Position of Pier 4       #inches
	  set XPier5        [expr $XPier4+$WB];  # X Position of Pier 5       #inches
	  set XPDeltaPier   [expr $XPier5+$WB];  # X Position of P-Delta Pier #inches
	  set YBase                        0.0;  # Y Elevation of Base        #inches
	  set YFloor2        [expr $YBase+$HS];  # Y Elevation of Floor 1     #inches
	  set YFloor3      [expr $YFloor2+$HS];  # Y Elevation of Floor 2     #inches
	  set YRoof        [expr $YFloor3+$HS];  # Y Elevation of Floor 3     #inches
#############################################################################################################################################
#                                                             lOADS INFORMATION                                                             #
#############################################################################################################################################
	# Step 2 - Part 01 - Define Distributed Loads (See Page 7 of "Session 05.pdf" File)
	  set DF       96.0;  # Floor Dead Load for Gravitational Weight Calculation #psf
	  set SDF      86.0;  # Floor Dead Load for Seismic Weight Calculation       #psf
	  set DR       83.0;  # Roof Dead Load without Penthouse                     #psf
	  set DP      116.0;  # Penthouse Dead Load                                  #psf
	  set DE       13.0;  # Structure Elements Weight                            #psf
	  set L        20.0;  # Roof and Floor Live Loads                            #psf
# -------------------------------------------------------------------------------------------------------------------------------------------
	# Step 2 - Part 02 - Calculate Gravitational Load Values (See Pages 8 and 9 of "Session 05.pdf" File)
	  set GWR 		            [expr  ((($DR+$DE+$L)*($NX*$NZ)*($WB*$WB))/144000.0)+((($DP+$DE)*1.0*$NP*($WB*$WB))/144000.0)];  # Roof Gravitational Weight                         #kips	               
	  set GWF                   [expr  ((($DF+$DE+$L)*$NX*$NZ*($WB*$WB))/144000.0)];                                             # Lower Floors Gravitational Weight                 #kips	
      set RoofGLoadPDeltaPier   [expr  $GWR*(($NZ-1.0)/(2.0*$NZ))];                                                              # Roof Gravitational Load for P-Delta Pier          #kips
      set RoofGLoadPier1and5    [expr  $GWR*(1.0/(2.0*$NX*2.0*$NZ))];                                                            # Roof Gravitational Load for Piers 1 and 5         #kips
      set RoofGLoadPier2to4     [expr  $GWR*(1.0/(1.0*$NX*2.0*$NZ))];                                                            # Roof Gravitational Load for Piers 2 to 4          #kips
      set FloorGLoadPDeltaPier  [expr  $GWF*(($NZ-1.0)/(2.0*$NZ))];                                                              # Lower Floors Gravitational Load for P-Delta Pier  #kips
      set FloorGLoadPier1and5   [expr  $GWF*(1.0/(2.0*$NX*2.0*$NZ))];                                                            # Lower Floors Gravitational Load for Piers 1 and 5 #kips
      set FloorGLoadPier2to4    [expr  $GWF*(1.0/(1.0*$NX*2.0*$NZ))];                                                            # Lower Floors Gravitational Load for Piers 2 to 4  #kips
# -------------------------------------------------------------------------------------------------------------------------------------------	
	# Step 2 - Part 03 - Calculate Lateral Load Values (See Pages 8 and 10 of "Session 05.pdf" File)
	  set SWR                   [expr  ((($DR+$DE)*($NX*$NZ)*($WB*$WB))/144000.0)+((($DP+$DE)*1.0*$NP*($WB*$WB))/144000.0)];                               # Roof Seismic Weight                         #kips	
	  set SWF                   [expr  ((($SDF+$DE)*$NX*$NZ*($WB*$WB))/144000.0)];                                                                         # Lower Floors Seismic Weight                 #kips	
	  set TSW                   [expr  $SWR+(2.0*$SWF)];                                                                                                   # Frame Total Seismic Weight                  #kips
	  set SLR                   [expr  (($SWR*($YRoof*$YRoof))/(($SWR*($YRoof*$YRoof))+($SWF*($YFloor3*$YFloor3))+($SWF*($YFloor2*$YFloor2))))*$TSW];      # Roof Total Lateral Load                     #kips
	  set SLF3                  [expr  (($SWF*($YFloor3*$YFloor3))/(($SWR*($YRoof*$YRoof))+($SWF*($YFloor3*$YFloor3))+($SWF*($YFloor2*$YFloor2))))*$TSW];  # Floor 3 Total Lateral Load                  #kips
	  set SLF2                  [expr  (($SWF*($YFloor2*$YFloor2))/(($SWR*($YRoof*$YRoof))+($SWF*($YFloor3*$YFloor3))+($SWF*($YFloor2*$YFloor2))))*$TSW];  # Floor 2 Total Lateral Load                  #kips
      set RoofLLoadPier1and5    [expr  ($SLR/2.0)*(1.0/(2.0*$NX))];                                                                                        # Roof Lateral Load for Piers 1 and 5         #kips
      set RoofLLoadPier2to4     [expr  ($SLR/2.0)*(1.0/(1.0*$NX))];                                                                                        # Roof Lateral Load for Piers 2 to 4          #kips
      set Floor3LLoadPier1and5  [expr  ($SLF3/2.0)*(1.0/(2.0*$NX))];                                                                                       # Floor 3 Lateral Load for Piers 1 and 5      #kips
      set Floor3LLoadPier2to4   [expr  ($SLF3/2.0)*(1.0/(1.0*$NX))];                                                                                       # Floor 3 Lateral Load for Piers 2 to 4       #kips
      set Floor2LLoadPier1and5  [expr  ($SLF2/2.0)*(1.0/(2.0*$NX))];                                                                                       # Floor 2 Lateral Load for Piers 1 and 5      #kips
      set Floor2LLoadPier2to4   [expr  ($SLF2/2.0)*(1.0/(1.0*$NX))];                                                                                       # Floor 2 Lateral Load for Piers 2 to 4       #kips
	  puts "Frame Seismic Weight is [expr $TSW/2] kips" 
#############################################################################################################################################
#                                                            MEMBERS INFORMATION                                                            #
#############################################################################################################################################
	# Step 3 - Part 01 - Define Material Properties (See Page 11 of "Session 05.pdf" File)
	  set Ec       23200.0;  # Elasticity Modulus for Columns Steel #kip/in^2
	  set Eb       29000.0;  # Elasticity Modulus for Beams Steel   #kip/in^2
	  set Fyc         50.0;  # Yeild Strength for Columns           #kip/in^2
	  set Fyb         36.0;  # Yeild Strength for Beams             #kip/in^2
	  set Ryc          1.1;  # Yield Strength Ratio for Columns
      set Ryb          1.5;  # Yield Strength Ratio for Beams
# -------------------------------------------------------------------------------------------------------------------------------------------
	# Step 3 - Part 02 - Define Section Properties for Different Members (See Page 11 of "Session 05.pdf" File)
	  # Exterior Columns (W14X257) 
		set AExteriorColumns              75.6;  # Cross-Section Area #in^2
		set IExteriorColumns            3400.0;  # Moment of Inertia  #in^4
		set ZExteriorColumns             487.0;  # Modulus of Plastic #in^3
	  # Interior Columns (W14X311) 
		set AInteriorColumns              91.4;  # Cross-Section Area #in^2
		set IInteriorColumns            4330.0;  # Moment of Inertia  #in^4
		set ZInteriorColumns             603.0;  # Modulus of Plastic #in^3
	  # Floor 2 Beams (W33X118) 
		set AFloor2Beams                  34.7;  # Cross-Section Area #in^2
		set IFloor2Beams                5900.0;  # Moment of Inertia  #in^4
		set ZFloor2Beams                 415.0;  # Modulus of Plastic #in^3
	  # Floor 3 Beams (W30X99) 
		set AFloor3Beams                  29.1;  # Cross-Section Area #in^2
		set IFloor3Beams                3990.0;  # Moment of Inertia  #in^4
		set ZFloor3Beams                 312.0;  # Modulus of Plastic #in^3
	  # Roof Beams (W27X94) 
		set ARoofBeams                    27.7;  # Cross-Section Area #in^2
		set IRoofBeams                  3270.0;  # Moment of Inertia  #in^4
		set ZRoofBeams                   278.0;  # Modulus of Plastic #in^3
# -------------------------------------------------------------------------------------------------------------------------------------------
	# Step 3 - Part 03 - Pre-Define Rigid Element Properties (See Pages 11, 16 and 17 of "Session 05.pdf" File)
	    set Arigid                            100000.0;  # A Very Large Cross-Section Area #in^2
	    set Erigid                             10000.0;  # A Very Large Elasticity Modulus #kip/in^2
	    set Irigid                         100000000.0;  # A Very Large Moment of Inertia  #in^4	
# -------------------------------------------------------------------------------------------------------------------------------------------
	# Step 3 - Part 04 - Pre-Define Zer-Stiffness Element Properties (See Pages 11, 16 and 17 of "Session 05.pdf" File)
	    set Ezero               0.00000000000000000001;  # A Very Low Elasticity Modulus #kip/in^2
#############################################################################################################################################
#                                                      MEMBERS MODELIN PARAMETERS                                                           #
#############################################################################################################################################
    # Step 4 - Part 01 - Pre-Define Equvalency Parameters
	  set a           10.0;  # Fema a                                (See Pages 12 and 13 of "Session 05.pdf" File)
	  set b           13.0;  # Fema b                                (See Pages 12 and 13 of "Session 05.pdf" File)
	  set c           0.60;  # Fema c                                (See Pages 12 and 13 of "Session 05.pdf" File)
	  set n           10.0;  # The Stiffness Modificatin Coefficient (See Page 14 of "Session 05.pdf" File)
	  set McMy        1.03;  # Strain-Hardening Ratio                (See Page 15 of "Session 05.pdf" File)
# -------------------------------------------------------------------------------------------------------------------------------------------
    # Step 4 - Part 02 - Calculate Modeling Parameters for Columns (See Pages 14, 16 and 17 of "Session 05.pdf" File)
	  # Columns
	    # Pier 1 Elastic Columns
	      set P1A                            $AExteriorColumns;  # Cross-Section Area #in^2
	      set P1E                                          $Ec;  # Elasticity Modulus #kip/in^2
	      set P1I      [expr  (($n+1.0)/$n)*$IExteriorColumns];  # Moment of Inertia  #in^4
	    # Piers 2 to 4 Elastic Columns
	      set P2to4A                         $AInteriorColumns;  # Cross-Section Area #in^2
	      set P2to4E                                       $Ec;  # Elasticity Modulus #kip/in^2
	      set P2to4I   [expr  (($n+1.0)/$n)*$IInteriorColumns];  # Moment of Inertia  #in^4
	    # Pier 5 Elastic Columns
	      set P5A                            $AExteriorColumns;  # Cross-Section Area #in^2
	      set P5E                                          $Ec;  # Elasticity Modulus #kip/in^2
	      set P5I                            $IExteriorColumns;  # Moment of Inertia  #in^4	
	    # P-Delta Pier Rigid Columns            
	      set PDA                                      $Arigid;  # Cross-Section Area #in^2
	      set PDE                                      $Erigid;  # Elasticity Modulus #kip/in^2
	      set PDI                                      $Irigid;  # Moment of Inertia  #in^4
# -------------------------------------------------------------------------------------------------------------------------------------------
    # Step 4 - Part 03 - Calculate Modeling Parameters for Beams and Truss Links (See Pages 14, 16 and 17 of "Session 05.pdf" File)		  
	  # Beams
	    # Bays 1 to 3 Elastic Beams
		  # Floor 2
	        set F2B1to3A                         $AFloor2Beams;  # Cross-Section Area #in^2
	        set F2B1to3E                                   $Eb;  # Elasticity Modulus #kip/in^2
	        set F2B1to3I   [expr  (($n+1.0)/$n)*$IFloor2Beams];  # Moment of Inertia  #in^4
		  # Floor 3
	        set F3B1to3A                         $AFloor3Beams;  # Cross-Section Area #in^2
	        set F3B1to3E                                   $Eb;  # Elasticity Modulus #kip/in^2
	        set F3B1to3I   [expr  (($n+1.0)/$n)*$IFloor3Beams];  # Moment of Inertia  #in^4
		  # Roof
	        set FRB1to3A                           $ARoofBeams;  # Cross-Section Area #in^2
	        set FRB1to3E                                   $Eb;  # Elasticity Modulus #kip/in^2
	        set FRB1to3I     [expr  (($n+1.0)/$n)*$IRoofBeams];  # Moment of Inertia  #in^4
	    # Bay 4 Elastic Beams
		  # Floor 2
	        set F2B4A                            $AFloor2Beams;  # Cross-Section Area #in^2
	        set F2B4E                                      $Eb;  # Elasticity Modulus #kip/in^2
	        set F2B4I                            $IFloor2Beams;  # Moment of Inertia  #in^4
		  # Floor 3                             
	        set F3B4A                            $AFloor3Beams;  # Cross-Section Area #in^2
	        set F3B4E                                      $Eb;  # Elasticity Modulus #kip/in^2
	        set F3B4I                            $IFloor3Beams;  # Moment of Inertia  #in^4
		  # Roof                                
	        set FRB4A                              $ARoofBeams;  # Cross-Section Area #in^2
	        set FRB4E                                      $Eb;  # Elasticity Modulus #kip/in^2
	        set FRB4I                              $IRoofBeams;  # Moment of Inertia  #in^4
	    # Bay 5 Truss Links
		  # Floor 2
	        set F2B5A                                  $Arigid;  # Cross-Section Area #in^2
	        set F2B5E                                  $Erigid;  # Elasticity Modulus #kip/in^2
		  # Floor 3                               
	        set F3B5A                                  $Arigid;  # Cross-Section Area #in^2
	        set F3B5E                                  $Erigid;  # Elasticity Modulus #kip/in^2
		  # Roof		                          
	        set FRB5A                                  $Arigid;  # Cross-Section Area #in^2
	        set FRB5E                                  $Erigid;  # Elasticity Modulus #kip/in^2
# -------------------------------------------------------------------------------------------------------------------------------------------
    # Step 4 - Part 04 - Calculate Modeling Parameters for Column Springs (See Pages 15, 16 and 17 of "Session 05.pdf" File)
	  # Column Springs
	    # Pier 1 Ibara-Krawinkler Springs                  
		  set P1SMy                                                                                                  [expr  $Ryc*$Fyc*$ZExteriorColumns];  # Yeild Moment #kips-in
	      set P1SK                                                                                    [expr  ($n+1.0)*((6.0*$Ec*$IExteriorColumns)/$HS)];  # Stiffness    #kips-in
	      set P1STetap                                                                                                [expr  $a*($n+1.0)*($P1SMy/$P1SK)];  # Tetap        #Rad
	      set P1STetapc                                                                                              [expr  1.0*($n+1.0)*($P1SMy/$P1SK)];  # Tetapc       #Rad
	      set P1STetau                                                                                                [expr  $b*($n+1.0)*($P1SMy/$P1SK)];  # Tetau        #Rad
	      set P1Sk                                                                                                                                    $c;  # k            
	      set P1Salpha                     [expr  (($McMy-1.0)*$P1SMy*$HS)/((($n+1.0)*6.0*$Ec*$IExteriorColumns*$P1STetap)-($n*($McMy-1.0)*$P1SMy*$HS))];  # alpha     
	    # Piers 2 to 4 Ibara-Krawinkler Springs                  
		  set P2to4SMy                                                                                               [expr  $Ryc*$Fyc*$ZInteriorColumns];  # Yeild Moment #kips-in
	      set P2to4SK                                                                                 [expr  ($n+1.0)*((6.0*$Ec*$IInteriorColumns)/$HS)];  # Stiffness    #kips-in
	      set P2to4STetap                                                                                       [expr  $a*($n+1.0)*($P2to4SMy/$P2to4SK)];  # Tetap        #Rad	
	      set P2to4STetapc                                                                                     [expr  1.0*($n+1.0)*($P2to4SMy/$P2to4SK)];  # Tetapc       #Rad
	      set P2to4STetau                                                                                       [expr  $b*($n+1.0)*($P2to4SMy/$P2to4SK)];  # Tetau        #Rad
	      set P2to4Sk                                                                                                                                 $c;  # k         
	      set P2to4Salpha         [expr  (($McMy-1.0)*$P2to4SMy*$HS)/((($n+1.0)*6.0*$Ec*$IInteriorColumns*$P2to4STetap)-($n*($McMy-1.0)*$P2to4SMy*$HS))];  # alpha        	  
	    # Pier 5 Zero-Stiffness Springs          
		  set P5SE                                                                                                                                $Ezero;  # Elasticity Modulus #kip/in^2
	    # P-Delta Pier Zero-Stiffness Springs                                                                                                     
		  set PDSE                                                                                                                                $Ezero;  # Elasticity Modulus #kip/in^2
# -------------------------------------------------------------------------------------------------------------------------------------------
    # Step 4 - Part 05 - Calculate Modeling Parameters for Beam Springs (See Pages 15, 16 and 17 of "Session 05.pdf" File)
	  # Beams Springs
	    # Bays 1 to 3 Ibara-Krawinkler Springs
		  # Floor 2
		    set F2B1to3SMy                                                                                               [expr  $Ryb*$Fyb*$ZFloor2Beams];  # Yeild Moment #kips-in
	        set F2B1to3SK                                                                                 [expr  ($n+1.0)*((6.0*$Eb*$IFloor2Beams)/$WB)];  # Stiffness    #kips-in
	        set F2B1to3STetap                                                                               [expr  $a*($n+1.0)*($F2B1to3SMy/$F2B1to3SK)];  # Tetap        #Rad	
	        set F2B1to3STetapc                                                                             [expr  1.0*($n+1.0)*($F2B1to3SMy/$F2B1to3SK)];  # Tetapc       #Rad
	        set F2B1to3STetau                                                                               [expr  $b*($n+1.0)*($F2B1to3SMy/$F2B1to3SK)];  # Tetau        #Rad
	        set F2B1to3Sk                                                                                                                             $c;  # k         
	        set F2B1to3Salpha   [expr  (($McMy-1.0)*$F2B1to3SMy*$WB)/((($n+1.0)*6.0*$Ec*$IFloor2Beams*$F2B1to3STetap)-($n*($McMy-1.0)*$F2B1to3SMy*$WB))];  # alpha    
		  # Floor 3
		    set F3B1to3SMy                                                                                               [expr  $Ryb*$Fyb*$ZFloor3Beams];  # Yeild Moment #kips-in
	        set F3B1to3SK                                                                                 [expr  ($n+1.0)*((6.0*$Eb*$IFloor3Beams)/$WB)];  # Stiffness    #kips-in
	        set F3B1to3STetap                                                                               [expr  $a*($n+1.0)*($F3B1to3SMy/$F3B1to3SK)];  # Tetap        #Rad	
	        set F3B1to3STetapc                                                                             [expr  1.0*($n+1.0)*($F3B1to3SMy/$F3B1to3SK)];  # Tetapc       #Rad
	        set F3B1to3STetau                                                                               [expr  $b*($n+1.0)*($F3B1to3SMy/$F3B1to3SK)];  # Tetau        #Rad
	        set F3B1to3Sk                                                                                                                             $c;  # k   
	        set F3B1to3Salpha   [expr  (($McMy-1.0)*$F3B1to3SMy*$WB)/((($n+1.0)*6.0*$Ec*$IFloor3Beams*$F3B1to3STetap)-($n*($McMy-1.0)*$F3B1to3SMy*$WB))];  # alpha     
		  # Roof
		    set FRB1to3SMy                                                                                                [expr  $Ryb*$Fyb*$ZRoofBeams];  # Yeild Moment #kips-in
	        set FRB1to3SK                                                                                  [expr  ($n+1.0)*((6.0*$Eb*$IRoofBeams)/$WB)];  # Stiffness    #kips-in
	        set FRB1to3STetap                                                                              [expr  $a*($n+1.0)*($FRB1to3SMy/$FRB1to3SK)];  # Tetap        #Rad	
	        set FRB1to3STetapc                                                                            [expr  1.0*($n+1.0)*($FRB1to3SMy/$FRB1to3SK)];  # Tetapc       #Rad
	        set FRB1to3STetau                                                                              [expr  $b*($n+1.0)*($FRB1to3SMy/$FRB1to3SK)];  # Tetau        #Rad
	        set FRB1to3Sk                                                                                                                            $c;  # k         
	        set FRB1to3Salpha    [expr  (($McMy-1.0)*$FRB1to3SMy*$WB)/((($n+1.0)*6.0*$Ec*$IRoofBeams*$FRB1to3STetap)-($n*($McMy-1.0)*$FRB1to3SMy*$WB))];  # alpha    
	    # Bay 4 Zero-Stiffness Springs
	      # Floor 2		 
		    set F2B4SE                                                                                                                           $Ezero;  # Elasticity Modulus #kip/in^2 
	      # Floor 3		                                                                                                                       
		    set F3B4SE                                                                                                                           $Ezero;  # Elasticity Modulus #kip/in^2 
	      # Roof	                                                                                                                           
		    set FRB4SE                                                                                                                           $Ezero;  # Elasticity Modulus #kip/in^2 
# -------------------------------------------------------------------------------------------------------------------------------------------
    # Step 4 - Part 06 - Define the Default Properties for Plastic Hinge Springs, based on Modified Ibarra Krawinkler Deterioration Model 			
	  set  LS  10000.0;		set  cS  1.0;		set  DN  1.0;				
      set  LK  10000.0;     set  cK  1.0;       set  DP  1.0;
      set  LA  10000.0;     set  cA  1.0;
      set  LD  10000.0;     set  cD  1.0;
#############################################################################################################################################
#                                                          PRE-MODELING DEFINITIONS                                                         #
#############################################################################################################################################
	# Step 05 - Set Up the Geometric Transformer
		set  GeomTransfTag  1;		         # The Transformer Tag is Saved in a Separate Variable to Make Member Definitions Easier.
		geomTransf  Linear  $GeomTransfTag;  # for "P-Delta" Transformer, Just Change the "Linear" to "PDelta".
#############################################################################################################################################
#                                                              NODES DEFINITION                                                             #
#############################################################################################################################################	
    # Step 06 - Define the Actual Nodes (See Page 16 of "Session 05.pdf" File)
      # Command: node  nodeID  X[in]  Y[in]
      # nodeID Convention:  "xy"   -->     x = Pier #    y = Floor # 
		# Base Nodes
		  node  11  $XPier1         $YBase; 	
		  node  21  $XPier2         $YBase;
		  node  31  $XPier3         $YBase;
		  node  41  $XPier4         $YBase;
		  node  51  $XPier5         $YBase;
		  node  61  $XPDeltaPier    $YBase;
		# Floor 2 Nodes
		  node  12  $XPier1       $YFloor2;
		  node  22  $XPier2       $YFloor2;
		  node  32  $XPier3       $YFloor2;
		  node  42  $XPier4       $YFloor2;
		  node  52  $XPier5       $YFloor2;
		  node  62  $XPDeltaPier  $YFloor2;
		# Floor 3 Nodes
		  node  13  $XPier1       $YFloor3;
		  node  23  $XPier2       $YFloor3;
		  node  33  $XPier3       $YFloor3;
		  node  43  $XPier4       $YFloor3;
		  node  53  $XPier5       $YFloor3;
		  node  63  $XPDeltaPier  $YFloor3;
		# Roof Nodes
		  node  14  $XPier1         $YRoof;
		  node  24  $XPier2         $YRoof;
		  node  34  $XPier3         $YRoof;
		  node  44  $XPier4         $YRoof;
		  node  54  $XPier5         $YRoof;
		  node  64  $XPDeltaPier    $YRoof;
# -------------------------------------------------------------------------------------------------------------------------------------------
    # Step 07 - Assign Boundary Condidtions (See Page 16 of "Session 05.pdf" File)
	  # Command: fix  nodeID  dxFixity  dyFixity  rzFixity
	  # Fixity Values: 1 = constrained; 0 = unconstrained
		# Fix the Base of the Building
	      # Pier 1              # Pier 2              # Pier 3              # Pier 4              # Pier 5              # P-Delta Pier		
		    fix  11  1  1  1;     fix  21  1  1  1;	    fix  31  1  1  1;	  fix  41  1  1  1;     fix  51  1  1  1;	  fix  61  1  1  1;
# -------------------------------------------------------------------------------------------------------------------------------------------
	# Step 08 - Create Diaphragm at Each Floor by Constraining the Actual Nodes in X-Direction ("xy" Nodes) (See Page 16 of "Session 05.pdf" File)
	  # Command: equalDOF  $MasterNodeID  $SlaveNodeID  $dof1
	    # Pier 2                 # Pier 3                 # Pier 4                 # Pier 5                 # P-Delta Pier
	      equalDOF  12  22  1;     equalDOF  12  32  1;     equalDOF  12  42  1;     equalDOF  12  52  1;	  equalDOF  12  62  1;	# Floor 2
		  equalDOF  13  23  1;     equalDOF  13  33  1;     equalDOF  13  43  1;     equalDOF  13  53  1;     equalDOF  13  63  1;	# Floor 3
		  equalDOF  14  24  1;     equalDOF  14  34  1;     equalDOF  14  44  1;     equalDOF  14  54  1;     equalDOF  14  64  1;	# Roof
# -------------------------------------------------------------------------------------------------------------------------------------------
    # Step 09 - Define the Virtual Nodes for Rotational Springs (See Page 16 of "Session 05.pdf" File)
	  # Command: node  nodeID  X[in]  Y[in]
	  # nodeID Convention:  "xya"   -->     x = Pier #    y = Floor #    a = Location Relative to Beam-Column Joint
	  #                        a    -->     8 = Left      9 = Right      6 = Below      7 = Above 
		# Virtual Nodes at the Top of Base	                # Virtual Nodes at the Bottom of Roof
		  node  117  $XPier1         $YBase; 		   	      node  146  $XPier1         $YRoof;
		  node  217  $XPier2         $YBase;		          node  246  $XPier2         $YRoof; 
		  node  317  $XPier3         $YBase;		   	      node  346  $XPier3         $YRoof;
		  node  417  $XPier4         $YBase;		   	      node  446  $XPier4         $YRoof;
		  node  517  $XPier5         $YBase;		   	      node  546  $XPier5         $YRoof;
		  node  617  $XPDeltaPier    $YBase;		   	      node  646  $XPDeltaPier    $YRoof;
		# Virtual Nodes at the Top of Floor 2		        # Virtual Nodes at the Bottom of Floor 2
		  node  127  $XPier1       $YFloor2;		   	      node  126  $XPier1       $YFloor2;
		  node  227  $XPier2       $YFloor2;		   	      node  226  $XPier2       $YFloor2; 
		  node  327  $XPier3       $YFloor2;		   	      node  326  $XPier3       $YFloor2; 
		  node  427  $XPier4       $YFloor2;		   	      node  426  $XPier4       $YFloor2;
		  node  527  $XPier5       $YFloor2;		   	      node  526  $XPier5       $YFloor2;
		  node  627  $XPDeltaPier  $YFloor2;		   	      node  626  $XPDeltaPier  $YFloor2;
		# Virtual Nodes at the Top of Floor 3		        # Virtual Nodes at the Bottom of Floor 3
		  node  137  $XPier1       $YFloor3;		   	      node  136  $XPier1       $YFloor3;
		  node  237  $XPier2       $YFloor3;		   	      node  236  $XPier2       $YFloor3;
		  node  337  $XPier3       $YFloor3;		   	      node  336  $XPier3       $YFloor3; 
		  node  437  $XPier4       $YFloor3;		   	      node  436  $XPier4       $YFloor3;
		  node  537  $XPier5       $YFloor3;		   	      node  536  $XPier5       $YFloor3;
		  node  637  $XPDeltaPier  $YFloor3;		   	      node  636  $XPDeltaPier  $YFloor3;		
	    # Virtual Nodes at the Right Side of Pier 1	        # Virtual Nodes at the Left Side of Pier 5			
		  node  129  $XPier1       $YFloor2;		   	      node  528  $XPier5       $YFloor2;				
		  node  139  $XPier1       $YFloor3;		   	      node  538  $XPier5       $YFloor3;				
		  node  149  $XPier1         $YRoof;		   	      node  548  $XPier5         $YRoof;				
	    # Virtual Nodes at the Right Side of Pier 2	        # Virtual Nodes at the Left Side of Pier 2	    	
		  node  229  $XPier2       $YFloor2;		   	      node  228  $XPier2       $YFloor2;						
		  node  239  $XPier2       $YFloor3;		   	      node  238  $XPier2       $YFloor3;					
		  node  249  $XPier2         $YRoof;		   	      node  248  $XPier2         $YRoof;						
	    # Virtual Nodes at the Right Side of Pier 3	        # Virtual Nodes at the Left Side of Pier 3	    	
		  node  329  $XPier3       $YFloor2;		          node  328  $XPier3       $YFloor2;						
		  node  339  $XPier3       $YFloor3;		          node  338  $XPier3       $YFloor3;						
		  node  349  $XPier3         $YRoof;		          node  348  $XPier3         $YRoof;							
	    # Virtual Nodes at the Right Side of Pier 4	        # Virtual Nodes at the Left Side of Pier 4	    	
		  node  429  $XPier4       $YFloor2;		   	      node  428  $XPier4       $YFloor2;						
		  node  439  $XPier4       $YFloor3;		   	      node  438  $XPier4       $YFloor3;						
		  node  449  $XPier4         $YRoof;		   	      node  448  $XPier4         $YRoof;	
#############################################################################################################################################
#                                                             MEMBERS DEFINITION                                                            #
#############################################################################################################################################
    # Step 10 - Part 01 - Define Piers 1 to 5 Columns (See Pages 16 and 17 of "Session 05.pdf" File)
	  # Command: element  elasticBeamColumn  $eleID  $iNode  $jNode  $A  $E  $I  $transfID
	  # eleID convention:   "axy"   -->     x = Pier #    y = Story #    a = Type of Element
	  #                      a      -->     1 = Actual Column
	    # Pier 1 Columns
	      element elasticBeamColumn  111  117  126   $P1A     $P1E     $P1I    $GeomTransfTag;  # Base to Floor 2 Column
		  element elasticBeamColumn  112  127  136   $P1A     $P1E     $P1I    $GeomTransfTag;  # Floor 2 to Floor 3 Column
	      element elasticBeamColumn  113  137  146   $P1A     $P1E     $P1I    $GeomTransfTag;  # Floor 3 to Roof Column
	    # Pier 2 Columns                                                              
	      element elasticBeamColumn  121  217  226  $P2to4A  $P2to4E  $P2to4I  $GeomTransfTag;  # Base to Floor 2 Column
		  element elasticBeamColumn  122  227  236  $P2to4A  $P2to4E  $P2to4I  $GeomTransfTag;  # Floor 2 to Floor 3 Column
	      element elasticBeamColumn  123  237  246  $P2to4A  $P2to4E  $P2to4I  $GeomTransfTag;  # Floor 3 to Roof Column		  
	    # Pier 3 Columns                                          
	      element elasticBeamColumn  131  317  326  $P2to4A  $P2to4E  $P2to4I  $GeomTransfTag;  # Base to Floor 2 Column
		  element elasticBeamColumn  132  327  336  $P2to4A  $P2to4E  $P2to4I  $GeomTransfTag;  # Floor 2 to Floor 3 Column
	      element elasticBeamColumn  133  337  346  $P2to4A  $P2to4E  $P2to4I  $GeomTransfTag;  # Floor 3 to Roof Column	
	    # Pier 4 Columns                                   
	      element elasticBeamColumn  141  417  426  $P2to4A  $P2to4E  $P2to4I  $GeomTransfTag;  # Base to Floor 2 Column
		  element elasticBeamColumn  142  427  436  $P2to4A  $P2to4E  $P2to4I  $GeomTransfTag;  # Floor 2 to Floor 3 Column
	      element elasticBeamColumn  143  437  446  $P2to4A  $P2to4E  $P2to4I  $GeomTransfTag;  # Floor 3 to Roof Column			  
	    # Pier 5 Columns                                                              
	      element elasticBeamColumn  151  517  526   $P5A     $P5E     $P5I    $GeomTransfTag;  # Base to Floor 2 Column
		  element elasticBeamColumn  152  527  536   $P5A     $P5E     $P5I    $GeomTransfTag;  # Floor 2 to Floor 3 Column
	      element elasticBeamColumn  153  537  546   $P5A     $P5E     $P5I    $GeomTransfTag;  # Floor 3 to Roof Column	
# -------------------------------------------------------------------------------------------------------------------------------------------
    # Step 10 - Part 02 - Define P-Delta Pier Columns (See Pages 16 and 17 of "Session 05.pdf" File)
	  # Command: element  elasticBeamColumn  $eleID  $iNode  $jNode  $A  $E  $I  $transfID
	  # eleID convention:   "axy"   -->     x = Pier #    y = Story #    a = Type of Element
	  #                      a      -->     2 = P-Delta Column
	    # P-Delta Pier Columns  
	      element elasticBeamColumn  261  617  626   $PDA     $PDE     $PDI    $GeomTransfTag;  # Base to Floor 2 Column
		  element elasticBeamColumn  262  627  636   $PDA     $PDE     $PDI    $GeomTransfTag;  # Floor 2 to Floor 3 Column
	      element elasticBeamColumn  263  637  646   $PDA     $PDE     $PDI    $GeomTransfTag;  # Floor 3 to Roof Column
# -------------------------------------------------------------------------------------------------------------------------------------------
    # Step 11 - Define Bays 1 to 3 Beams (See Pages 16 and 17 of "Session 05.pdf" File)
	  # Command: element  elasticBeamColumn  $eleID  $iNode  $jNode  $A  $E  $I  $transfID
	  # eleID convention:   "axy"   -->     x = Bay #    y = Story #    a = Type of Element
	  #                      a      -->     3 = Actual Beam
	    # Bay 1 Beams
	      element elasticBeamColumn  312  129  228  $F2B1to3A  $F2B1to3E  $F2B1to3I  $GeomTransfTag;  # Floor 2 Beam 
	      element elasticBeamColumn  313  139  238  $F3B1to3A  $F3B1to3E  $F3B1to3I  $GeomTransfTag;  # Floor 3 Beam 
	      element elasticBeamColumn  314  149  248  $FRB1to3A  $FRB1to3E  $FRB1to3I  $GeomTransfTag;  # Roof Beam 
	    # Bay 2 Beams                            
	      element elasticBeamColumn  322  229  328  $F2B1to3A  $F2B1to3E  $F2B1to3I  $GeomTransfTag;  # Floor 2 Beam 
	      element elasticBeamColumn  323  239  338  $F3B1to3A  $F3B1to3E  $F3B1to3I  $GeomTransfTag;  # Floor 3 Beam 
	      element elasticBeamColumn  324  249  348  $FRB1to3A  $FRB1to3E  $FRB1to3I  $GeomTransfTag;  # Roof Beam 
	    # Bay 3 Beams                                   
	      element elasticBeamColumn  332  329  428  $F2B1to3A  $F2B1to3E  $F2B1to3I  $GeomTransfTag;  # Floor 2 Beam 
	      element elasticBeamColumn  333  339  438  $F3B1to3A  $F3B1to3E  $F3B1to3I  $GeomTransfTag;  # Floor 3 Beam 
	      element elasticBeamColumn  334  349  448  $FRB1to3A  $FRB1to3E  $FRB1to3I  $GeomTransfTag;  # Roof Beam 
	    # Bay 4 Beams                                                               
	      element elasticBeamColumn  342  429  528   $F2B4A     $F2B4E     $F2B4I    $GeomTransfTag;  # Floor 2 Beam 
	      element elasticBeamColumn  343  439  538   $F3B4A     $F3B4E     $F3B4I    $GeomTransfTag;  # Floor 3 Beam  
	      element elasticBeamColumn  344  449  548   $FRB4A     $FRB4E     $FRB4I    $GeomTransfTag;  # Roof Beam 
# -------------------------------------------------------------------------------------------------------------------------------------------		
	# Step 12 - Define Bay 5 Rigid Links (See Pages 16 and 17 of "Session 05.pdf" File)
	  # Command 1: uniaxialMaterial  Elastic  $eleID  $E
	  # Command 2: element  truss  $eleID  $iNode  $jNode  $A  $eleID
	  # eleID convention:   "axy"   -->     x = Bay #    y = Story #    a = Type of Element
	  #                      a      -->     4 = Truss Link
	    # Bay 5 Truss Links  
		  uniaxialMaterial Elastic 452 $F2B5E;  element truss 452 52 62 $F2B5A 452;  # Floor 2 Link 
	      uniaxialMaterial Elastic 453 $F3B5E;  element truss 453 53 63 $F3B5A 453;  # Floor 3 Link  
		  uniaxialMaterial Elastic 454 $FRB5E;  element truss 454 54 64 $FRB5A 454;  # Roof Link 		
# -------------------------------------------------------------------------------------------------------------------------------------------
	# Step 13 - Define Piers 1 to 4 Ibara-Krawinkler Springs (See Pages 16 and 17 of "Session 05.pdf" File)
	  # Command 1: uniaxialMaterial  Bilin  $SpringID  $K  $alpha  $alpha  $My  $-My  $LS  $LK  $LA  $LD  $cS  $cK  $cA  $cD  $Tetap  $Tetap  $Tetapc  $Tetapc  $k  $k  $Tetau  $Tetau  $DP  $DN
	  # Command 2: element  zeroLength  $SpringID  $Actual_Node  $Virtual_Node  -mat  $SpringID  -dir  6
	  # Command 3: equalDOF  $MasterNodeID  $SlaveNodeID  $dof1  $dof2
	  # SpringID convention:   "axyb"   -->     x = Pier #    y = Story #    a = Element Type    b = Location in Story
	  #                         a       -->     5 = Column Spring
	  #                            b    -->     6 = Below     7 = Above
		# Pier 1 Springs
		  uniaxialMaterial Bilin 5117 $P1SK $P1Salpha $P1Salpha $P1SMy [expr -$P1SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P1STetap $P1STetap $P1STetapc $P1STetapc $P1Sk $P1Sk $P1STetau $P1STetau $DP $DN;
		  uniaxialMaterial Bilin 5126 $P1SK $P1Salpha $P1Salpha $P1SMy [expr -$P1SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P1STetap $P1STetap $P1STetapc $P1STetapc $P1Sk $P1Sk $P1STetau $P1STetau $DP $DN;
		  uniaxialMaterial Bilin 5127 $P1SK $P1Salpha $P1Salpha $P1SMy [expr -$P1SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P1STetap $P1STetap $P1STetapc $P1STetapc $P1Sk $P1Sk $P1STetau $P1STetau $DP $DN;
		  uniaxialMaterial Bilin 5136 $P1SK $P1Salpha $P1Salpha $P1SMy [expr -$P1SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P1STetap $P1STetap $P1STetapc $P1STetapc $P1Sk $P1Sk $P1STetau $P1STetau $DP $DN;
		  uniaxialMaterial Bilin 5137 $P1SK $P1Salpha $P1Salpha $P1SMy [expr -$P1SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P1STetap $P1STetap $P1STetapc $P1STetapc $P1Sk $P1Sk $P1STetau $P1STetau $DP $DN;
		  uniaxialMaterial Bilin 5146 $P1SK $P1Salpha $P1Salpha $P1SMy [expr -$P1SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P1STetap $P1STetap $P1STetapc $P1STetapc $P1Sk $P1Sk $P1STetau $P1STetau $DP $DN;
		  element zeroLength 5117 11 117 -mat 5117 -dir 6;  equalDOF 11 117 1 2;  # Base to Floor 2 Bottom Spring
		  element zeroLength 5126 12 126 -mat 5126 -dir 6;  equalDOF 12 126 1 2;  # Base to Floor 2 Top Spring
		  element zeroLength 5127 12 127 -mat 5127 -dir 6;  equalDOF 12 127 1 2;  # Floor 2 to Floor 3 Bottom Spring	
		  element zeroLength 5136 13 136 -mat 5136 -dir 6;  equalDOF 13 136 1 2;  # Floor 2 to Floor 3 Top Spring
		  element zeroLength 5137 13 137 -mat 5137 -dir 6;  equalDOF 13 137 1 2;  # Floor 3 to Roof Bottom Spring
		  element zeroLength 5146 14 146 -mat 5146 -dir 6;  equalDOF 14 146 1 2;  # Floor 3 to Roof Top Spring
		# Pier 2 Springs
		  uniaxialMaterial Bilin 5217 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5226 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5227 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5236 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5237 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5246 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  element zeroLength 5217 21 217 -mat 5217 -dir 6;  equalDOF 21 217 1 2;  # Base to Floor 2 Bottom Spring
		  element zeroLength 5226 22 226 -mat 5226 -dir 6;  equalDOF 22 226 1 2;  # Base to Floor 2 Top Spring
		  element zeroLength 5227 22 227 -mat 5227 -dir 6;  equalDOF 22 227 1 2;  # Floor 2 to Floor 3 Bottom Spring	
		  element zeroLength 5236 23 236 -mat 5236 -dir 6;  equalDOF 23 236 1 2;  # Floor 2 to Floor 3 Top Spring
		  element zeroLength 5237 23 237 -mat 5237 -dir 6;  equalDOF 23 237 1 2;  # Floor 3 to Roof Bottom Spring
		  element zeroLength 5246 24 246 -mat 5246 -dir 6;  equalDOF 24 246 1 2;  # Floor 3 to Roof Top Spring
		# Pier 3 Springs
		  uniaxialMaterial Bilin 5317 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5326 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5327 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5336 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5337 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5346 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  element zeroLength 5317 31 317 -mat 5317 -dir 6;  equalDOF 31 317 1 2;  # Base to Floor 2 Bottom Spring
		  element zeroLength 5326 32 326 -mat 5326 -dir 6;  equalDOF 32 326 1 2;  # Base to Floor 2 Top Spring
		  element zeroLength 5327 32 327 -mat 5327 -dir 6;  equalDOF 32 327 1 2;  # Floor 2 to Floor 3 Bottom Spring
		  element zeroLength 5336 33 336 -mat 5336 -dir 6;  equalDOF 33 336 1 2;  # Floor 2 to Floor 3 Top Spring
		  element zeroLength 5337 33 337 -mat 5337 -dir 6;  equalDOF 33 337 1 2;  # Floor 3 to Roof Bottom Spring
		  element zeroLength 5346 34 346 -mat 5346 -dir 6;  equalDOF 34 346 1 2;  # Floor 3 to Roof Top Spring
		# Pier 4 Springs                                                        
		  uniaxialMaterial Bilin 5417 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5426 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5427 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5436 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5437 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  uniaxialMaterial Bilin 5446 $P2to4SK $P2to4Salpha $P2to4Salpha $P2to4SMy [expr -$P2to4SMy] $LS $LK $LA $LD $cS $cK $cA $cD $P2to4STetap $P2to4STetap $P2to4STetapc $P2to4STetapc $P2to4Sk $P2to4Sk $P2to4STetau $P2to4STetau $DP $DN;
		  element zeroLength 5417 41 417 -mat 5417 -dir 6;  equalDOF 41 417 1 2;  # Base to Floor 2 Bottom Spring
		  element zeroLength 5426 42 426 -mat 5426 -dir 6;  equalDOF 42 426 1 2;  # Base to Floor 2 Top Spring
		  element zeroLength 5427 42 427 -mat 5427 -dir 6;  equalDOF 42 427 1 2;  # Floor 2 to Floor 3 Bottom Spring	
		  element zeroLength 5436 43 436 -mat 5436 -dir 6;  equalDOF 43 436 1 2;  # Floor 2 to Floor 3 Top Spring
		  element zeroLength 5437 43 437 -mat 5437 -dir 6;  equalDOF 43 437 1 2;  # Floor 3 to Roof Bottom Spring
		  element zeroLength 5446 44 446 -mat 5446 -dir 6;  equalDOF 44 446 1 2;  # Floor 3 to Roof Top Spring		
# -------------------------------------------------------------------------------------------------------------------------------------------
	# Step 14 - Define Pier 5 and P-Delta Pier Zero-Stiffness Springs (See Pages 16 and 17 of "Session 05.pdf" File)
	  # Command 1: uniaxialMaterial  Elastic  $SpringID  $E
	  # Command 2: element  zeroLength  $SpringID  $Actual_Node  $Virtual_Node  -mat  $SpringID  -dir  6
	  # Command 3: equalDOF  $MasterNodeID  $SlaveNodeID  $dof1  $dof2
	  # SpringID:          "axyb"   -->     x = Pier #    y = Story #    a = Element Type    b = Location in Story
	  #                     a       -->     5 = Column Spring	
	  #                        b    -->     6 = Below     7 = Above
		# Pier 5 Springs
		  uniaxialMaterial Elastic 5517 $P5SE;  element zeroLength 5517 51 517 -mat 5517 -dir 6;  equalDOF 51 517 1 2;  # Base to Floor 2 Bottom Spring
		  uniaxialMaterial Elastic 5526 $P5SE;  element zeroLength 5526 52 526 -mat 5526 -dir 6;  equalDOF 52 526 1 2;  # Base to Floor 2 Top Spring
		  uniaxialMaterial Elastic 5527 $P5SE;  element zeroLength 5527 52 527 -mat 5527 -dir 6;  equalDOF 52 527 1 2;  # Floor 2 to Floor 3 Bottom Spring
		  uniaxialMaterial Elastic 5536 $P5SE;  element zeroLength 5536 53 536 -mat 5536 -dir 6;  equalDOF 53 536 1 2;  # Floor 2 to Floor 3 Top Spring
		  uniaxialMaterial Elastic 5537 $P5SE;  element zeroLength 5537 53 537 -mat 5537 -dir 6;  equalDOF 53 537 1 2;  # Floor 3 to Roof Bottom Spring
		  uniaxialMaterial Elastic 5546 $P5SE;  element zeroLength 5546 54 546 -mat 5546 -dir 6;  equalDOF 54 546 1 2;  # Floor 3 to Roof Top Spring
		# P-Delta Pier Springs
		  uniaxialMaterial Elastic 5617 $PDSE;  element zeroLength 5617 61 617 -mat 5617 -dir 6;  equalDOF 61 617 1 2;  # Base to Floor 2 Bottom Spring
		  uniaxialMaterial Elastic 5626 $PDSE;  element zeroLength 5626 62 626 -mat 5626 -dir 6;  equalDOF 62 626 1 2;  # Base to Floor 2 Top Spring
		  uniaxialMaterial Elastic 5627 $PDSE;  element zeroLength 5627 62 627 -mat 5627 -dir 6;  equalDOF 62 627 1 2;  # Floor 2 to Floor 3 Bottom Spring
		  uniaxialMaterial Elastic 5636 $PDSE;  element zeroLength 5636 63 636 -mat 5636 -dir 6;  equalDOF 63 636 1 2;  # Floor 2 to Floor 3 Top Spring
		  uniaxialMaterial Elastic 5637 $PDSE;  element zeroLength 5637 63 637 -mat 5637 -dir 6;  equalDOF 63 637 1 2;  # Floor 3 to Roof Bottom Spring
		  uniaxialMaterial Elastic 5646 $PDSE;  element zeroLength 5646 64 646 -mat 5646 -dir 6;  equalDOF 64 646 1 2;  # Floor 3 to Roof Top Spring
# -------------------------------------------------------------------------------------------------------------------------------------------
	# Step 15 - Define Bays 1 to 3 Ibara-Krawinkler Springs (See Pages 16 and 17 of "Session 05.pdf" File)
	  # Command 1: uniaxialMaterial  Bilin  $SpringID  $K  $alpha  $alpha  $My  $-My  $LS  $LK  $LA  $LD  $cS  $cK  $cA  $cD  $Tetap  $Tetap  $Tetapc  $Tetapc  $k  $k  $Tetau  $Tetau  $DP  $DN
	  # Command 2: element  zeroLength  $SpringID  $Actual_Node  $Virtual_Node  -mat  $SpringID  -dir  6
	  # Command 3: equalDOF  $MasterNodeID  $SlaveNodeID  $dof1  $dof2
	  # SpringID:          "axyb"   -->     x = Pier #    y = Story #    a = Element Type    b = Location in Story
	  #                     a       -->     6 = Beam Spring 	
	  #                        b    -->     8 = Left      9 = Right	
		# Bay 1 Springs
	 	  uniaxialMaterial Bilin 6129 $F2B1to3SK $F2B1to3Salpha $F2B1to3Salpha $F2B1to3SMy [expr -$F2B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F2B1to3STetap $F2B1to3STetap $F2B1to3STetapc $F2B1to3STetapc $F2B1to3Sk $F2B1to3Sk $F2B1to3STetau $F2B1to3STetau $DP $DN;
	 	  uniaxialMaterial Bilin 6228 $F2B1to3SK $F2B1to3Salpha $F2B1to3Salpha $F2B1to3SMy [expr -$F2B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F2B1to3STetap $F2B1to3STetap $F2B1to3STetapc $F2B1to3STetapc $F2B1to3Sk $F2B1to3Sk $F2B1to3STetau $F2B1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6139 $F3B1to3SK $F3B1to3Salpha $F3B1to3Salpha $F3B1to3SMy [expr -$F3B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F3B1to3STetap $F3B1to3STetap $F3B1to3STetapc $F3B1to3STetapc $F3B1to3Sk $F3B1to3Sk $F3B1to3STetau $F3B1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6238 $F3B1to3SK $F3B1to3Salpha $F3B1to3Salpha $F3B1to3SMy [expr -$F3B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F3B1to3STetap $F3B1to3STetap $F3B1to3STetapc $F3B1to3STetapc $F3B1to3Sk $F3B1to3Sk $F3B1to3STetau $F3B1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6149 $FRB1to3SK $FRB1to3Salpha $FRB1to3Salpha $FRB1to3SMy [expr -$FRB1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $FRB1to3STetap $FRB1to3STetap $FRB1to3STetapc $FRB1to3STetapc $FRB1to3Sk $FRB1to3Sk $FRB1to3STetau $FRB1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6248 $FRB1to3SK $FRB1to3Salpha $FRB1to3Salpha $FRB1to3SMy [expr -$FRB1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $FRB1to3STetap $FRB1to3STetap $FRB1to3STetapc $FRB1to3STetapc $FRB1to3Sk $FRB1to3Sk $FRB1to3STetau $FRB1to3STetau $DP $DN;
	 	  element zeroLength 6129 12 129 -mat 6129 -dir 6;  equalDOF 12 129 1 2;  # Floor 2 Left Spring   
	 	  element zeroLength 6228 22 228 -mat 6228 -dir 6;  equalDOF 22 228 1 2;  # Floor 2 Right Spring        
		  element zeroLength 6139 13 139 -mat 6139 -dir 6;  equalDOF 13 139 1 2;  # Floor 3 Left Spring        
		  element zeroLength 6238 23 238 -mat 6238 -dir 6;  equalDOF 23 238 1 2;  # Floor 3 Right Spring      
		  element zeroLength 6149 14 149 -mat 6149 -dir 6;  equalDOF 14 149 1 2;  # Roof Left Spring        
		  element zeroLength 6248 24 248 -mat 6248 -dir 6;  equalDOF 24 248 1 2;  # Roof Right Spring      
		# Bay 2 Springs                                                              
	 	  uniaxialMaterial Bilin 6229 $F2B1to3SK $F2B1to3Salpha $F2B1to3Salpha $F2B1to3SMy [expr -$F2B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F2B1to3STetap $F2B1to3STetap $F2B1to3STetapc $F2B1to3STetapc $F2B1to3Sk $F2B1to3Sk $F2B1to3STetau $F2B1to3STetau $DP $DN;
	 	  uniaxialMaterial Bilin 6328 $F2B1to3SK $F2B1to3Salpha $F2B1to3Salpha $F2B1to3SMy [expr -$F2B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F2B1to3STetap $F2B1to3STetap $F2B1to3STetapc $F2B1to3STetapc $F2B1to3Sk $F2B1to3Sk $F2B1to3STetau $F2B1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6239 $F3B1to3SK $F3B1to3Salpha $F3B1to3Salpha $F3B1to3SMy [expr -$F3B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F3B1to3STetap $F3B1to3STetap $F3B1to3STetapc $F3B1to3STetapc $F3B1to3Sk $F3B1to3Sk $F3B1to3STetau $F3B1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6338 $F3B1to3SK $F3B1to3Salpha $F3B1to3Salpha $F3B1to3SMy [expr -$F3B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F3B1to3STetap $F3B1to3STetap $F3B1to3STetapc $F3B1to3STetapc $F3B1to3Sk $F3B1to3Sk $F3B1to3STetau $F3B1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6249 $FRB1to3SK $FRB1to3Salpha $FRB1to3Salpha $FRB1to3SMy [expr -$FRB1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $FRB1to3STetap $FRB1to3STetap $FRB1to3STetapc $FRB1to3STetapc $FRB1to3Sk $FRB1to3Sk $FRB1to3STetau $FRB1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6348 $FRB1to3SK $FRB1to3Salpha $FRB1to3Salpha $FRB1to3SMy [expr -$FRB1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $FRB1to3STetap $FRB1to3STetap $FRB1to3STetapc $FRB1to3STetapc $FRB1to3Sk $FRB1to3Sk $FRB1to3STetau $FRB1to3STetau $DP $DN;
	 	  element zeroLength 6229 22 229 -mat 6229 -dir 6;  equalDOF 22 229 1 2;  # Floor 2 Left Spring  
	 	  element zeroLength 6328 32 328 -mat 6328 -dir 6;  equalDOF 32 328 1 2;  # Floor 2 Right Spring  
		  element zeroLength 6239 23 239 -mat 6239 -dir 6;  equalDOF 23 239 1 2;  # Floor 3 Left Spring 
		  element zeroLength 6338 33 338 -mat 6338 -dir 6;  equalDOF 33 338 1 2;  # Floor 3 Right Spring 
		  element zeroLength 6249 24 249 -mat 6249 -dir 6;  equalDOF 24 249 1 2;  # Roof Left Spring   
		  element zeroLength 6348 34 348 -mat 6348 -dir 6;  equalDOF 34 348 1 2;  # Roof Right Spring 
		# Bay 3 Springs                                                         
	 	  uniaxialMaterial Bilin 6329 $F2B1to3SK $F2B1to3Salpha $F2B1to3Salpha $F2B1to3SMy [expr -$F2B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F2B1to3STetap $F2B1to3STetap $F2B1to3STetapc $F2B1to3STetapc $F2B1to3Sk $F2B1to3Sk $F2B1to3STetau $F2B1to3STetau $DP $DN;
	 	  uniaxialMaterial Bilin 6428 $F2B1to3SK $F2B1to3Salpha $F2B1to3Salpha $F2B1to3SMy [expr -$F2B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F2B1to3STetap $F2B1to3STetap $F2B1to3STetapc $F2B1to3STetapc $F2B1to3Sk $F2B1to3Sk $F2B1to3STetau $F2B1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6339 $F3B1to3SK $F3B1to3Salpha $F3B1to3Salpha $F3B1to3SMy [expr -$F3B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F3B1to3STetap $F3B1to3STetap $F3B1to3STetapc $F3B1to3STetapc $F3B1to3Sk $F3B1to3Sk $F3B1to3STetau $F3B1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6438 $F3B1to3SK $F3B1to3Salpha $F3B1to3Salpha $F3B1to3SMy [expr -$F3B1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $F3B1to3STetap $F3B1to3STetap $F3B1to3STetapc $F3B1to3STetapc $F3B1to3Sk $F3B1to3Sk $F3B1to3STetau $F3B1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6349 $FRB1to3SK $FRB1to3Salpha $FRB1to3Salpha $FRB1to3SMy [expr -$FRB1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $FRB1to3STetap $FRB1to3STetap $FRB1to3STetapc $FRB1to3STetapc $FRB1to3Sk $FRB1to3Sk $FRB1to3STetau $FRB1to3STetau $DP $DN;
		  uniaxialMaterial Bilin 6448 $FRB1to3SK $FRB1to3Salpha $FRB1to3Salpha $FRB1to3SMy [expr -$FRB1to3SMy] $LS $LK $LA $LD $cS $cK $cA $cD $FRB1to3STetap $FRB1to3STetap $FRB1to3STetapc $FRB1to3STetapc $FRB1to3Sk $FRB1to3Sk $FRB1to3STetau $FRB1to3STetau $DP $DN;
	 	  element zeroLength 6329 32 329 -mat 6329 -dir 6;  equalDOF 32 329 1 2;  # Floor 2 Left Spring  
	 	  element zeroLength 6428 42 428 -mat 6428 -dir 6;  equalDOF 42 428 1 2;  # Floor 2 Right Spring  
		  element zeroLength 6339 33 339 -mat 6339 -dir 6;  equalDOF 33 339 1 2;  # Floor 3 Left Spring 
		  element zeroLength 6438 43 438 -mat 6438 -dir 6;  equalDOF 43 438 1 2;  # Floor 3 Right Spring 
		  element zeroLength 6349 34 349 -mat 6349 -dir 6;  equalDOF 34 349 1 2;  # Roof Left Spring   
		  element zeroLength 6448 44 448 -mat 6448 -dir 6;  equalDOF 44 448 1 2;  # Roof Right Spring 
# -------------------------------------------------------------------------------------------------------------------------------------------
	# Step 16 - Define Bay 4 Zero-Stiffness Springs (See Pages 16 and 17 of "Session 05.pdf" File)
	  # Command 1: uniaxialMaterial  Elastic  $SpringID  $E
	  # Command 2: element  zeroLength  $SpringID  $Actual_Node  $Virtual_Node  -mat  $SpringID  -dir  6
	  # Command 3: equalDOF  $MasterNodeID  $SlaveNodeID  $dof1  $dof2
	  # SpringID:          "axyb"   -->     x = Pier #    y = Story #    a = Element Type    b = Location in Story
	  #                     a       -->     6 = Beam Spring 	
	  #                        b    -->     8 = Left      9 = Right	
	    # Bay 4 Springs
		  uniaxialMaterial Elastic 6429 $F2B4SE;  element zeroLength 6429 42 429 -mat 6429 -dir 6;  equalDOF 42 429 1 2;  # Floor 2 Left Spring  
		  uniaxialMaterial Elastic 6528 $F2B4SE;  element zeroLength 6528 52 528 -mat 6528 -dir 6;  equalDOF 52 528 1 2;  # Floor 2 Right Spring  
		  uniaxialMaterial Elastic 6439 $F3B4SE;  element zeroLength 6439 43 439 -mat 6439 -dir 6;  equalDOF 43 439 1 2;  # Floor 3 Left Spring 
		  uniaxialMaterial Elastic 6538 $F3B4SE;  element zeroLength 6538 53 538 -mat 6538 -dir 6;  equalDOF 53 538 1 2;  # Floor 3 Right Spring 
		  uniaxialMaterial Elastic 6449 $FRB4SE;  element zeroLength 6449 44 449 -mat 6449 -dir 6;  equalDOF 44 449 1 2;  # Roof Left Spring   
		  uniaxialMaterial Elastic 6548 $FRB4SE;  element zeroLength 6548 54 548 -mat 6548 -dir 6;  equalDOF 54 548 1 2;  # Roof Right Spring 
# -------------------------------------------------------------------------------------------------------------------------------------------	
	# Optional: Create a Group Consisted of the Springs Defined in the Actual Piers and Bays 
	                   # Pier 1 Springs                 # Pier 2 Springs                 # Pier 3 Springs                 # Pier 4 Springs                 # Pier 5 Springs                 # Floor 2 Springs                          # Floor 3 Springs                          # Roof Springs
        region 1 -ele    5117 5126 5127 5136 5137 5146    5217 5226 5227 5236 5237 5246    5317 5326 5327 5336 5337 5346    5417 5426 5427 5436 5437 5446    5517 5526 5527 5536 5537 5546    6129 6228 6229 6328 6329 6428 6429 6528    6139 6238 6239 6338 6339 6438 6439 6538    6149 6248 6249 6348 6349 6448 6449 6548;
#############################################################################################################################################
#                                                    ANALYZATION FOR GRAVITATIONAL LOADS                                                    #
#############################################################################################################################################
	# Step 17 - Part 01 - Apply the Gravitational Loads
	  #Command: pattern Plain $PatternID Constant
	  pattern Plain 101 Constant {
	    # Downward Point Loads on Actual Nodes
	    # Command: load  nodeID  $Fx[kips]  $Fy[kips]  $Mz[kips-in]
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
# -------------------------------------------------------------------------------------------------------------------------------------------	
	# Step 17 - Part 02 - Analysis for Gravitational Loads: Load-Controlled Static Analysis				
	  constraints Plain;						
	  numberer RCM;							
	  system BandGeneral;						
	  test NormDispIncr 1.0e-6 600;				
	  algorithm Newton;								
	  integrator LoadControl 0.01;		
	  analysis Static;					
	  analyze 100;
# -------------------------------------------------------------------------------------------------------------------------------------------	
	# Step 18 - Maintain Constant Gravity Loads and Reset Time to Zero
	  loadConst -time 0.0
#############################################################################################################################################
#                                                             OUTPUT DEFINITION                                                             #
#############################################################################################################################################
	# Step 19 - Part 01 - Set Up the Drift Recorders (See Page 19 of "Session 05.pdf" File)
	  # Command: recorder  Drift  -file      Output_File_Name             -iNode  The_Node_to_Record_Drift_From  -jNode  The_Node_to_Record_Drift_for  -dof  Direction_Parallel_to_Drift  -perpDirn  Direction_Perpendicular_to_Drift 
		         recorder  Drift  -file  LinearFloor2DriftFromBase.txt    -iNode                11               -jNode              12                -dof               1               -perpDirn                 2;
		         recorder  Drift  -file  LinearFloor3DriftFromBase.txt    -iNode                11               -jNode              13                -dof               1               -perpDirn                 2;
		         recorder  Drift  -file  LinearFloor4DriftFromBase.txt    -iNode                11               -jNode              14                -dof               1               -perpDirn                 2;
		         recorder  Drift  -file  LinearFloor2DriftFromFloor1.txt  -iNode                11               -jNode              12                -dof               1               -perpDirn                 2;
		         recorder  Drift  -file  LinearFloor3DriftFromFloor2.txt  -iNode                12               -jNode              13                -dof               1               -perpDirn                 2;
		         recorder  Drift  -file  LinearFloor4DriftFromFloor3.txt  -iNode                13               -jNode              14                -dof               1               -perpDirn                 2;
# -------------------------------------------------------------------------------------------------------------------------------------------	
	# Step 19 - Part 02 - Set Up Shear Reaction Recorders (See Page 19 of "Session 05.pdf" File)
	  # Command: recorder  Node   -file    Output_File_Name     -node/region          Node/Region#          -dof  Target_DoFs  Type
		         recorder  Node   -file  LinearFloor1Shear.txt  -node         117  217  317  417  517  617  -dof       1       reaction;
		         recorder  Node   -file  LinearFloor2Shear.txt  -node         127  227  327  427  527  627  -dof       1       reaction;
		         recorder  Node   -file  LinearFloor3Shear.txt  -node         137  237  337  437  537  637  -dof       1       reaction;
# -------------------------------------------------------------------------------------------------------------------------------------------	
	# Step 19 - Part 03 - Set Up the Springs Rotation Recorder (See Page 19 of "Session 05.pdf" File)
	  # Command: recorder  Element  -file    Output_File_Name         -ele/region  Element/Region#  Type
		         recorder  Element  -file  LinearSpringsRotation.txt  -region            1          deformation;
# -------------------------------------------------------------------------------------------------------------------------------------------	
	
#############################################################################################################################################
#                                                       ANALYZATION FOR LATERAL LOADS                                                       #
#############################################################################################################################################
	# Step 20 - Part 01 - Assign the Lateral Loads
	  #Command: pattern Plain $PatternID Linear
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
	  }
# -------------------------------------------------------------------------------------------------------------------------------------------
	# Step 20 - Part 02 - Displacement Checker Parameters Parameters
	  set IDctrlNode                         14;  # Node Where Displacement is Read for Displacement Control
	  set IDctrlDOF                           1;  # Degree of Freedom Where Displacement is Read for Displacement Control (1 = X-Displacement Displacement)
	  set TargetDrift                      0.05;  # Maximum Preferred Roof Drift  # 8% Drift
	  set Dincr                           0.001;  # Displacement Increment		
	  set Dmax   [expr $TargetDrift*$HBuilding];  # Maximum Displacement of Pushover
	  set Nsteps       [expr int($Dmax/$Dincr)];  # Number of Pushover Analysis Steps
# -------------------------------------------------------------------------------------------------------------------------------------------
	# Step 20 - Part 03 - Analysis Commands
	  constraints Plain;					                            # How it Handles Boundary Conditions
	  numberer RCM;						                                # Renumber DoFs to Minimize Band-Width (Optimization)
	  system BandGeneral;				   	                            # How to Store and Solve the System of Equations in the Analysis
	  test NormUnbalance 1.0e-5 1000;		                            # Tolerance, Maximum Number of Iterations
	  algorithm Newton;					                                # Use Newton's Solution Algorithm: Updates Tangent Stiffness at Every Iteration
	  integrator DisplacementControl  $IDctrlNode  $IDctrlDOF  $Dincr;  # Use Displacement-Controlled Analysis
	  analysis Static;					                                # Define Type of Analysis: Static for Pushover
	  set ok [analyze $Nsteps];		                                    # This Will Return Zero if No Convergence Problems Were Encountered