<!--- Parámetros requeridos --->
<cfif isDefined("Url.tran") and len(trim(#url.tran#))>
   <cfquery name="rsCCtran" datasource="#session.dsn#">
      select CCTpago,* from CCTransacciones where CCTcodigo = '#url.tran#'  and  Ecodigo = #session.ecodigo# 
   </cfquery>
</cfif>
<cfif isdefined('rsCCtran') and rsCCtran.CCTpago eq 1> 
 
  <cfoutput>      
     <script language="javascript">
	    parent.document.getElementById("divTpago").style.display = '';	
		parent.document.getElementById("divlblTpago").style.display = '';	
							
        parent.document.forms.form1.elements.TipoPago.options[0] = new Option('Cheque', 'C');
	    parent.document.forms.form1.elements.TipoPago.options[1] = new Option('Transferencia', 'T');
		parent.document.forms.form1.elements.TipoPago.options[2] = new Option('Tarjeta', 'TA');		
     </script>	
  </cfoutput>  
<cfelse>
    <cfoutput>    
     <script language="javascript">
	    parent.document.getElementById("divTpago").style.display = 'none';
		parent.document.getElementById("divlblTpago").style.display = 'none';
		 parent.document.forms.form1.elements.TipoPago.options[0] = new Option('', '');
     </script>	
  </cfoutput>  

</cfif>

                
