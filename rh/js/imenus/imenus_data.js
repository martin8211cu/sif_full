
document.write("												\
<div style='position:relative;display:none;z-index:0;'><ul id='imenus0'>								\
														\
														\
	<!-- Main Item 0... --><li><a href='#'>Who We Are</a>							\
														\
														\
		<!-- *SUB MENU* --><ul style='width:140px;'>							\
		<li><a href='sample_link.html'>Overview</a></li>						\
		<li><a href='#'>Mission & Goals</a></li>							\
		<li><a href='sample_link.html'>History</a></li>							\
		<li><a href='sample_link.html'>Management</a></li>						\
		<li><a href='sample_link.html'>Working at Tyco</a></li>						\
		<li><a href='sample_link.html'>Press Center</a></li>						\
		<li><a href='#'>Worldwide</a>									\
														\
			<!-- Sub Menu --><ul style='width:140px; top:1px; left:134px;'>				\
			<li><a href='sample_link.html'>Europe</a></li>						\
			<li><a href='sample_link.html'>Asia</a></li>						\
			<li><a href='sample_link.html'>US & Canada</a></li>					\
			<li><a href='sample_link.html'>Mexico</a></li>						\
			<li><a href='sample_link.html'>Australia</a></li>					\
			<li><a href='sample_link.html'>Middle East</a></li>					\
			<!-- *END SUB* --></ul></li>								\
														\
														\
		<li><a href='#'>Board of Directors</a>								\
														\
			<!-- Sub Menu --><ul style='width:140px; top:1px; left:134px;'>				\
			<li><a href='sample_link.html'>Overview</a></li>					\
			<li><a href='sample_link.html'>Electronics</a></li>					\
			<li><a href='sample_link.html'>Fire & Security</a></li>					\
			<li><a href='sample_link.html'>Healthcare</a></li>					\
			<li><a href='sample_link.html'>Plastics & Adhesives</a></li>				\
			<li><a href='sample_link.html'>Engineered Producs</a></li>				\
			<li><a href='sample_link.html'>Tyco Worldwide</a></li>					\
			<!-- *END SUB* --></ul></li>								\
														\
														\
		<li><a href='#'>Customers</a></li>								\
		<!-- *END SUB* --></ul>										\
														\
														\
	<!-- Main Item 1... --><li><a href='#'>Our Comitment</a>						\
														\
														\
		<!-- *SUB MENU* --><ul style='width:140px;'>							\
		<li><a href='sample_link.html'>Overview</a></li>						\
		<li><a href='sample_link.html'>People & Values</a></li>						\
		<li><a href='sample_link.html'>Governance</a></li>						\
		<li><a href='sample_link.html'>Community</a></li>						\
		<li><a href='sample_link.html'>Environmental</a></li>						\
		<!-- *END SUB* --></ul></li>									\
														\
														\
	<!-- Main Item 2... --><li><a href='#'>Our Business</a>							\
														\
														\
		<!-- Sub Menu --><ul style='width:140px;'>							\
		<li><a href='sample_link.html'>Overview</a></li>						\
		<li><a href='sample_link.html'>Electronics</a></li>						\
		<li><a href='sample_link.html'>Fire & Security</a></li>						\
		<li><a href='sample_link.html'>Healthcare</a></li>						\
		<li><a href='sample_link.html'>Plastics & Adhesives</a></li>					\
		<li><a href='sample_link.html'>Engineered Producs</a></li>					\
		<li><a href='sample_link.html'>Tyco Worldwide</a></li>						\
		<!-- *END SUB* --></ul></li>									\
														\
														\
	<!-- Main Item 3... --><li><a href='#'>Investors</a>							\
														\
														\
		<!-- Sub Menu --><ul style='width:140px;'>							\
		<li><a href='sample_link.html'>Overview</a></li>						\
		<li><a href='sample_link.html'>Stock Quotes</a></li>						\
		<!-- *END SUB* --></ul></li>									\
														\
														\
<div style='clear:left;'></div></ul></div>");







/*

          Tips & Tricks

             1: Adjust the "function menudata0()" numeric id in the statement below to match the numeric id of
                the id='imenus0' statement within the menu structure and links secion above.  The numbers must 
                match for the menu to work, multiple menus may be used on a single page by adding new sections 
                with new id's.

             2: To specifically define settings for an individual item or container, apply classes or inline styles
                directly to the UL and A tags in the HTML tags which define your menus structure and links above.

             3: Use the parameter options below to define borders and padding.  Borders and padding specified
                within the menus HTML structure may cause positioning and actual sizing to be offset a bit in
                some browsers.
 
*/




/*-------------------------------------------------
************* Parameter Settings ******************
---------------------------------------------------*/


function menudata0()
{
	
	

    /*---------------------------------------------
    Expand Icon Images
    ---------------------------------------------*/


        //Expand Images are the icons which indicate an additional sub menu level.)
	
        this.main_expand_image_style = "background: url(arrow_main.gif) center right no-repeat;";
        this.main_expand_image_hover_style = "background: url(arrow_main.gif) center right no-repeat;";

	this.subs_expand_image_style = "background: url(arrow_sub.gif) center right no-repeat;";
	this.subs_expand_image_hover_style = "background: url(arrow_sub.gif) center right no-repeat;";



    /*---------------------------------------------
    Menu Container Settings
    ---------------------------------------------*/

	//Main Container

	   this.main_container_border_width = "1px"
           this.main_container_border_style = "none"

           this.main_container_styles =   "background-color:#06437d;		\
                                           border-color:#769bba;"




	//Sub Containers

           this.subs_container_padding = "5px, 5px, 5px, 5px"
           this.subs_container_border_width = "1px"
           this.subs_container_border_style = "solid"

           this.subs_container_styles =   "background-color:#cce3f8;		\
                                           border-color:#356595;"



    /*---------------------------------------------
    Menu Item Settings
    ---------------------------------------------*/


	//Main Items

           this.main_item_padding = "2px,5px,2px,5px"
                  
           this.main_item_styles =        "text-decoration:none;		\
                                           font-weight:bold;			\
                                           font-family:Arial;			\
                                           font-size:12px;			\
                                           background-color:#06437d;		\
                                           color:#e6e6e6;			\
                                           border-style:none;			\
                                           text-align:center;			\
                                           border-style:none;			\
                                           border-color:#000000;		\
                                           border-width:0px;"
					   


           this.main_item_hover_styles =  "background-color:#cce3f8;		\
                                           text-decoration:normal;		\
                                           color:#111111;"

           this.main_item_active_styles = "background-color:#cce3f8;		\
                                           text-decoration:normal;		\
                                           color:#111111;"



	//Sub Items

           this.subs_item_padding = "2px,5px,2px,5px"
           
           this.subs_item_styles =        "text-decoration:none;		\
                                           font-face:Arial;			\
                                           font-size:11px;			\
                                           font-weight:normal;			\
                                           background-color:#cce3f8;		\
                                           color:#111111;			\
                                           border-style:none;			\
                                           text-align:left;			\
                                           border-style:none;			\
                                           border-color:#000000;		\
                                           border-width:1px;"	

           this.subs_item_hover_styles =  "background-color:#ffffff;		\
                                           color:#255585;"

           this.subs_item_active_styles = "background-color:#ffffff;		\
                                           color:#255585;"




   /*---------------------------------------------
    Additional Setting
    ---------------------------------------------*/


        //Main Menu Orientation

           this.main_is_horizontal = true
	

        //Main Menu Item Widths 

           this.main_item_width = 140			//default width for all items

           //this.main_item_width0 = 100		//optional specific width for the first menu item
           //this.main_item_width1 = 100		//optional specific width for the second menu item...
           //this.main_item_width2 = 100		//optional specific width for the second menu item...


        //The mouse off and mouse over delay for sub menus

           this.menu_showhide_delay = 150;

}


