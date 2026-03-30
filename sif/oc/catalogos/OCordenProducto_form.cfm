<cfset mododet = 'ALTA'>
<cfif isdefined("form.Aid") and len(trim(form.Aid))>
	<cfquery datasource="#session.dsn#" name="rsFormD">
		select op.OCid
			 , op.OCPlinea
			 , op.Aid
			 , op.Ecodigo
			 , a.Ucodigo
			 , op.OCPcantidad
			 , op.OCPprecioUnitario
			 , op.OCPprecioTotal
			 , op.OCitem_num
			 , op.OCport_num
			 , op.CFformato
		  from OCordenProducto op
		  	inner join Articulos a
			  	on op.Aid = a.Aid
		 where op.Aid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
		 and   op.OCid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid#">
		 and   op.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	</cfquery>
	<cfset mododet = 'CAMBIO'>
<cfelse>
	<cfquery name="rsLinea" datasource="#session.DSN#">
		select coalesce(max(OCPlinea),0) + 1 as OCPlinea  from OCordenProducto 
		where  OCid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid#">
		and   Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	 </cfquery>
</cfif>	



<cfquery datasource="#session.dsn#" name="rsUnidades">
	select Ucodigo, Udescripcion 
	from Unidades 
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
		and Utipo in (0,2)
	order by Udescripcion
</cfquery>

<cfoutput>
<form name="form2" id="form2" method="post" action="OCordenProducto_sql.cfm">
	<table summary="Tabla de entrada">
		<tr>
			<td colspan="2" class="subTitulo">
				Productos de una orden comercial
			</td>
		</tr>
		<tr>
			<td valign="top" nowrap>
				<strong>L&iacute;nea</strong>
			</td>
			<td valign="top">
				<cfif isdefined("rsFormD.OCPlinea") and len(trim(rsFormD.OCPlinea))>
					<cf_monto	name="OCPlinea" 
							value="#HTMLEditFormat(rsFormD.OCPlinea)#"
							size="5" decimales="0" tabindex="12"
					>
				<cfelse>
					<cf_monto	name="OCPlinea" 
								value="#HTMLEditFormat(rsLinea.OCPlinea)#"
								size="5" decimales="0" tabindex="12"
					>
				</cfif>
			</td>
		</tr>		
		
		<tr>
			<td valign="top">
				<strong>Artículo</strong>
			</td>
			<td valign="top">
				<cfif mododet neq 'ALTA'>
					<cfquery name="rsArticulo" datasource="#session.DSN#">
							select Aid, Acodigo, Adescripcion from Articulos 
							where Ecodigo =	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and Aid = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormD.Aid#">
					</cfquery>
					<cf_sifarticulos query=#rsArticulo#  form="form2" size="30" tabindex="12" UcodigoOculto="ucodigo_oculto">
				<cfelse>
					<cf_sifarticulos  form="form2" size="30" tabindex="12" UcodigoOculto="ucodigo_oculto">
				</cfif>				
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Unidad de Medida</strong>
			</td>
			<td valign="top">
				<input type="hidden" name="Ucodigo_oculto" id="Ucodigo_oculto" value="<cfif mododet NEQ 'ALTA'>#rsFormD.Ucodigo#</cfif>">
				<select name="Ucodigo" tabindex="-1" onfocus="LvarAct=this.selectedIndex;" onchange="this.selectedIndex=LvarAct;">
						<option value="">(escoja un articulo)</option>
					<cfloop query="rsUnidades">
						<cfif mododet EQ 'ALTA'>
							<option value="#rsUnidades.Ucodigo#">#rsUnidades.Udescripcion#</option>
						<cfelse>
							<option value="#rsUnidades.Ucodigo#" <cfif rsFormD.Ucodigo EQ rsUnidades.Ucodigo>selected</cfif>>#rsUnidades.Udescripcion#</option>
						</cfif>
					</cfloop>						
				</select>
			</td>
		</tr>
<script language="javascript">
	function funcAcodigo()
	{
		var LvarUcodigo = document.form2.Ucodigo;
		var LvarNewUcodigo = document.form2.ucodigo_oculto.value;
		
		if (LvarNewUcodigo.replace(" ","") == "")
		{
			if (LvarUcodigo.value == "")
				return false;
			alert ('Articulo no tiene unidad de Medida');
			document.form2.Acodigo.value = "";
			LvarUcodigo.selectedIndex=0;
			return false;
		}
		for (var i=0; i<=LvarUcodigo.options.length; i++)
		{
			if (LvarUcodigo.options[i].value == LvarNewUcodigo)
			{
				LvarUcodigo.selectedIndex=i;
				return;
			}
		}
	}
</script>
		<tr>
			<td valign="top">
				<strong>Cantidad Contratada</strong>
			</td>
			<td valign="top">
				<cfif isdefined("rsFormD.OCPcantidad") and len(trim(rsFormD.OCPcantidad))>
					<cf_monto	name="OCPcantidad" 
							value="#HTMLEditFormat(rsFormD.OCPcantidad)#"  onChange="javascript:CalculaTotal();"
							size="18" decimales="2" tabindex="14"
					>
				<cfelse>
					<cf_monto   name="OCPcantidad" 
								value=""
								size="18" decimales="2" tabindex="14"  onChange="javascript:CalculaTotal();"
					>
				</cfif>				
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Precio Unitario</strong>
			</td>
			<td valign="top">
				<cfif isdefined("rsFormD.OCPprecioUnitario") and len(trim(rsFormD.OCPprecioUnitario))>
					<cf_monto	name="OCPprecioUnitario" 
							value="#HTMLEditFormat(rsFormD.OCPprecioUnitario)#"
							size="18" decimales="2" tabindex="15" onChange="javascript:CalculaTotal();"
					>
				<cfelse>
					<cf_monto   name="OCPprecioUnitario" 
								value=""
								size="18" decimales="2" tabindex="15"  onChange="javascript:CalculaTotal();"
					>
				</cfif>	
			</td>
		</tr>
		<tr>
			<td valign="top">
				<strong>Precio Total</strong>
			</td>
			<td valign="top">
				<cfif isdefined("rsFormD.OCPprecioTotal") and len(trim(rsFormD.OCPprecioTotal))>
					<cf_monto	name="OCPprecioTotal" 
							value="#HTMLEditFormat(rsFormD.OCPprecioTotal)#"
							size="18" decimales="2" tabindex="15" readonly="true"
					>
				<cfelse>
					<cf_monto   name="OCPprecioTotal" 
								value=""
								size="18" decimales="2" tabindex="15" readonly="true"
					>
				</cfif>	
			</td>
		</tr>

		<tr>
			<td valign="top" nowrap>
				<strong>Order Item</strong>
			</td>
			<td valign="top">
				<cfif isdefined("rsFormD.OCitem_num") and len(trim(rsFormD.OCitem_num))>
					<cf_monto	name="OCitem_num" 
							value="#HTMLEditFormat(rsFormD.OCitem_num)#"
							size="18" decimales="0" tabindex="16"
					>
				<cfelse>
					<cf_monto	name="OCitem_num" 
								value=""
								size="18" decimales="0" tabindex="16"
					>
				</cfif>
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Portafolio</strong>
			</td>
			<td valign="top">
				<cfif isdefined("rsFormD.OCport_num") and len(trim(rsFormD.OCport_num))>
					<cf_monto	name="OCport_num" 
							value="#HTMLEditFormat(rsFormD.OCport_num)#"
							size="18" decimales="0" tabindex="17"
					>
				<cfelse>
					<cf_monto	name="OCport_num" 
								value=""
								size="18" decimales="0" tabindex="17"
					>
				</cfif>			
				<input 
					type="hidden" 
					name="CFformato"
					id="CFformato"
					value="<cfif isdefined("rsFormD.CFformato") and len(trim(rsFormD.CFformato))>#rsFormD.CFformato#</cfif>" 
				>
			</td>
		</tr>
 		<tr>
			<td colspan="2" class="formButtons">
			<cfif mododet  EQ "CAMBIO">
				<cf_botones  modo='CAMBIO'>
			<cfelse>
				<cf_botones   modo='ALTA'>
			</cfif>
			</td>
		</tr>
	</table>
	<input type="hidden" name="OCid" value="#HTMLEditFormat(form.OCid)#">
	<iframe id="FRAMECJNEGRA" name="FRAMECJNEGRA" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" src="" style="visibility:hiddens"></iframe>
</form>
<cf_qforms form="form2" objForm="LobjQForm2">
	<cf_qformsRequiredField args="Aid, ID Artículo">
	<cf_qformsRequiredField args="Ucodigo, Unidad de Medida">
	<cf_qformsRequiredField args="OCPcantidad, Cantidad Contratada">
	<cf_qformsRequiredField args="OCPprecioUnitario, Precio Unitario">
</cf_qforms>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">
	function CalculaTotal() {
		var OCPcantidad 		 = new Number(qf(document.form2.OCPcantidad.value));
		var OCPprecioUnitario    = new Number(qf(document.form2.OCPprecioUnitario.value));
		OCPcantidad = OCPcantidad * OCPprecioUnitario ;
		document.form2.OCPprecioTotal.value = OCPcantidad;
		fm(document.form2.OCPprecioTotal,2)
	}
	
	function doConlisCcuenta() {
		var Cmayor = document.form2.Cmayor.value;
		var PARAM  = "ConlisCuentascontable.cfm?Cmayor="+ Cmayor;
		open(PARAM,'V1','left=110,top=100,scrollbars=yes,resizable=yes,width=900,height=650')
	}
	
	function validaMayor(valor) {
 		var Cmayor = valor;
		if(Cmayor != "" ) {
			var LvarCerosV = "0000" + trim(Cmayor);
			var LvarCerosN = LvarCerosV.length;
			Cmayor = LvarCerosV.substring(LvarCerosN-4,LvarCerosN);
			document.form2.Cmayor.value = Cmayor;
			var PARAMS = "?Cmayor="+Cmayor;
			var frame  = document.getElementById("FRAMECJNEGRA");
			document.form2.Cformato.value = '';
			frame.src 	= "validaCuenta.cfm" + PARAMS;
		} 

	}
	
	function validadetalle() {
		var Cmayor   = document.form2.Cmayor.value;
		if(Cmayor != ""  && Cformato != "") {
			var Cformato = document.form2.Cmayor.value +'-'+document.form2.CDetalle.value ;
			var PARAMS = "?Cmayor="+Cmayor+"&Cformato="+Cformato;
			var frame  = document.getElementById("FRAMECJNEGRA");
			document.form2.Cformato.value = '';
			frame.src 	= "validaCuenta.cfm" + PARAMS;
		}
		
	}	
	
	<!--- Alta --->
	
</script>

