<!--- Obtener la lista de cuentas que posee la persona --->
<cfquery name="rsCuentas" datasource="#Session.DSN#">
	select a.CTid, a.CUECUE, a.CTtipoUso,Habilitado
	from ISBcuenta a
	where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idpersona#">
	and a.CTtipoUso in ('U','A')
	<!---and a.CTtipoUso in ('U')---><!---MODIFICACION PARA QUE PERMITA AGREGAR Y CONFIGURAR SERVICIOS EN LA CUENTA DE ACCESO DE UN AGENTE--->
</cfquery>

<cfoutput>
<center>	
	<table border="0" cellpadding="2" cellspacing="0">
	<tr><td colspan="2">&nbsp;</td></tr>
	<!--- Mostrar las cuentas seleccionadas --->
	<cfloop query="rsCuentas">
	  <tr>
		<td align="right"><img src="/cfmx/saci/images/account.png" border="0"></td>
		<td nowrap>
			<cfif rsCuentas.CTtipoUso neq 'A'>
				<a href="javascript: goPage2('#Attributes.form#', 98, '#rsCuentas.CTid#', '#rsCuentas.CUECUE#', '#rsCuentas.Habilitado#');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" style="font-size:15px; border-bottom:thin;font-family:Georgia, "Times New Roman", Times, serif;">
					<cfif ExisteCuenta and rsCuentas.CTid EQ form.CTid ><strong></cfif>
						<cfif rsCuentas.CTtipoUso EQ 'U'>
						 	Cuenta 
							<cfif rsCuentas.CUECUE GT 0>
								#rsCuentas.CUECUE#
							<cfelse>
								&lt;Por Asignar&gt;
							</cfif>
						<cfelseif rsCuentas.CTtipoUso EQ 'A'>
							Cuenta de Acceso
						<cfelseif rsCuentas.CTtipoUso EQ 'F'>
							Cuenta de Especial
						</cfif>
					<cfif ExisteCuenta and rsCuentas.CTid EQ form.CTid ></strong></cfif>
				</a>
			<cfelse>
				<cfif ExisteCuenta and rsCuentas.CTid EQ form.CTid ><strong></cfif>
						<cfif rsCuentas.CTtipoUso EQ 'U'>
						 	Cuenta 
							<cfif rsCuentas.CUECUE GT 0>
								#rsCuentas.CUECUE#
							<cfelse>
								&lt;Por Asignar&gt;
							</cfif>
						<cfelseif rsCuentas.CTtipoUso EQ 'A'>
							Cuenta de Acceso
						<cfelseif rsCuentas.CTtipoUso EQ 'F'>
							Cuenta de Especial
						</cfif>
					<cfif ExisteCuenta and rsCuentas.CTid EQ form.CTid ></strong></cfif>
			</cfif>
			
		</td>
	  </tr>
	</cfloop>
	  
	  <!--- Nueva Cuenta --->
	  <tr>
		<td align="right"><img src="/cfmx/saci/images/file.png" border="0"></td>
		<td  nowrap><a href="javascript: goPage2('#Attributes.form#', 99);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" style="font-size:15px; border-bottom:thin;font-family:Georgia, "Times New Roman", Times, serif;"><cfif not ExisteCuenta><strong></cfif>Nueva<cfif not ExisteCuenta></strong></cfif></a></td>
	  </tr>
	</table>
</center>

<script language="javascript" type="text/javascript">
	function goPage2(f, paso) {
		if (paso == 99) {
			document.#Attributes.form#.paso.value = '1';
			document.#Attributes.form#.cue.value = '';
			document.#Attributes.form#.submit();
		}else
			if (paso == 98) {
				if(arguments[3] > 0)
					document.#Attributes.form#.paso.value = '1';
				else{
					if(arguments[4] == 1)//La cuenta esta Activa
						document.#Attributes.form#.paso.value = '2';
					else
						document.#Attributes.form#.paso.value = '1';
				}
				if (arguments[2] != undefined) {
					document.#Attributes.form#.cue.value = arguments[2];
				}					
				document.#Attributes.form#.submit();
			} else {
				document.#Attributes.form#.paso.value = paso;
				document.#Attributes.form#.submit();
			}	
	}
</script>

</cfoutput>