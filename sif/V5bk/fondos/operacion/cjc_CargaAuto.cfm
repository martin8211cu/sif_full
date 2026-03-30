<cfquery name="rs" datasource="#session.Fondos.dsn#">
	set nocount on	
	exec  cj_Carga_Automatica_pu
	@CJX19REL = #trim(url.CJX19REL)#
	,@TIPO    = '#trim(url.TIPO)#'
	set nocount off	
</cfquery>

<script language="JavaScript">
	<cfif rs.recordcount gt 0>
		<cfif url.TIPO EQ 'G'>
			window.parent.document.form1.CJX20TIP.value   	= '<cfoutput>#rs.CJX20TIP#</cfoutput>';
			
			window.parent.document.form1.CP9COD.value   	= '<cfoutput>#rs.CP9COD#</cfoutput>';
			window.parent.TraeDescripcionCP9COD('<cfoutput>#rs.CP9COD#</cfoutput>');
	
			
			window.parent.document.form1.EMPCED.value   	= '<cfoutput>#rs.EMPCED#</cfoutput>';
			window.parent.TraeDescripcionEMPCED('<cfoutput>#rs.EMPCED#</cfoutput>');
			
			window.parent.document.form1.DEPCOD.value   	= '<cfoutput>#rs.I04COD#</cfoutput>';
			window.parent.TraeDescripcionDEPCOD('<cfoutput>#rs.I04COD#</cfoutput>');
			
		
			window.parent.document.form1.PROCED.value  		= '<cfoutput>#rs.PROCED#</cfoutput>';
			window.parent.TraeDescripcionPROCED('<cfoutput>#rs.PROCED#</cfoutput>')
	
			window.parent.document.form1.CJX20FEF.value   	= '<cfoutput>#rs.CJX20FEF#</cfoutput>';
			
			window.parent.document.form1.CGE5COD.value   	= '<cfoutput>#rs.CGE5COD#</cfoutput>';
			window.parent.AgregarComboGR(window.parent.document.form1.CJM12ID,window.parent.document.form1.CGE5COD.value);
			
			window.parent.document.form1.CJM12ID.value  	= '<cfoutput>#rs.CJM12ID#</cfoutput>';
			window.parent.AgregarComboSG(window.parent.document.form1.CJM13ID,window.parent.document.form1.CJM12ID.value);
			
			window.parent.document.form1.CJM13ID.value   	= '<cfoutput>#rs.CJM13ID#</cfoutput>';
			window.parent.AgregarComboCTA(window.parent.document.form1.PR1COD,window.parent.document.form1.CJM13ID.value);		
			
			window.parent.document.form1.PR1COD.value   	= '<cfoutput>#rs.PR1COD#</cfoutput>';
			window.parent.AgregarComboPROY(window.parent.document.form1.PRT7IDE,window.parent.document.form1.PR1COD.value);
			
			window.parent.document.form1.PRT7IDE.value  	= '<cfoutput>#rs.PRT7IDE#</cfoutput>';
			window.parent.document.form1.CJX20NUF.focus();
			window.parent.validaLIQ ();
		<cfelse>
			window.parent.document.form1.EMPCED.value   	= '<cfoutput>#rs.EMPCED#</cfoutput>';
			window.parent.document.form1.EMPCOD.value   	= '<cfoutput>#rs.EMPCOD#</cfoutput>';
			window.parent.document.form1.NOMBRE.value   	= '<cfoutput>#trim(rs.NOMBRE)#</cfoutput>';			
			window.parent.document.form1.TR01NUT.value  	= '<cfoutput>#rs.TR01NUT#</cfoutput>';
			window.parent.document.form1.CJX23AUT.focus();
		</cfif>	
		
	</cfif>	
</script>

