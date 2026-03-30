
<cfparam name="Attributes.pathImage" type="any" default="/cfmx/sif/imagenes/modal/loadingSIF.gif"> 
<cfparam name="Attributes.divId" type="string" default="spinnerSIF">
<cfparam name="Attributes.FunctionShowName" type="string" default="showLoading">
<cfparam name="Attributes.FunctionHideName" type="string" default="hideLoading">

<!--- <cfdump var='#Attributes#'> --->
<!--- CSS --->
<style>
    #<cfoutput>#Attributes.divId#</cfoutput> {
    position: fixed;
    top: 0; left: 0; z-index: 999;
    width: 100vw; height: 100vh;
    background: rgba(0, 0, 0, 0.3);
    transition: opacity 0.2s;
    padding-top:20%;
    text-align:center;
    vertical-align:middle;
    
    display: flex;
    align-items: center; justify-content: center;
    visibility: hidden; opacity: 0;
    }

    #imageSpinnerSif {
        height: 75px;
        width: 75px;
    }
    
    #<cfoutput>#Attributes.divId#</cfoutput>.show { visibility: visible; opacity: 1; }
    
    html, body { margin: 0; }
</style>

<cfoutput>
    <div id="#Attributes.divId#">
        <img src="#Attributes.pathImage#" alt="Loading image" id="imageSpinnerSif">
    </div>

    <script language="javascript" type="text/javascript">
        function #Attributes.FunctionShowName# () {
            document.getElementById("#Attributes.divId#").classList.add("show");
        }

        function #Attributes.FunctionHideName# () {
            document.getElementById("#Attributes.divId#").classList.remove("show");
        }
    </script>

</cfoutput>

<cfexit>