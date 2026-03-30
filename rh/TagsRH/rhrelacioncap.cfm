<cfset def = QueryNew('dato')>

<cfparam name="Attributes.Conlis" default="true" type="boolean"> <!--- Indica si se va a permitir abrir un conlis de Empleados --->
<cfparam name="Attributes.index" default="0" type="numeric"> <!--- Se utiliza cuando se quiere colocar varios tags en la misma pantalla --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.frame" default="FRhabilidad" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.size" default="30" type="numeric"> <!--- Tamaño del Nombre del Empleado --->
<cfparam name="Attributes.tabindex" default="0" type="numeric"> <!--- TabIndex del Campo Editable --->
<cfparam name="Attributes.estado" default="3" type="numeric"> <!--- TabIndex del Campo Editable --->
<cfparam name="Attributes.tipo" default="C" type="string"> <!--- C:conlis, S:combo --->

<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>

<cfif Attributes.tipo eq 'C'>
	<script language="JavaScript" type="text/javascript">
		function doConlis_relacioncap<cfoutput>#index#</cfoutput>() {
			var width = 600;
			var height = 500;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			
			<cfoutput>
				var nuevo = window.open('/cfmx/rh/Utiles/ConlisRelacionCap.cfm?f=#Attributes.form#&p1=RHEECid#index#&p2=RHEECdescripcion#index#&p3=#Attributes.estado#','ListaRelaciones','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			</cfoutput>
			
			nuevo.focus();
		}
		
		function ResetRelacionCap<cfoutput>#index#</cfoutput>() {
			document.<cfoutput>#Attributes.form#.RHHid#index#</cfoutput>.value = "";
			document.<cfoutput>#Attributes.form#.RHHcodigo#index#</cfoutput>.value = "";
			document.<cfoutput>#Attributes.form#.RHHdescripcion#index#</cfoutput>.value = "";
		}
	</script>
</cfif>

<cfoutput>
<table border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td>
			<cfif Attributes.tipo eq 'C'>
				<input type="hidden" name="RHEECid#index#" value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHEECid#index#")>#Evaluate("Attributes.query.RHEECid#index#")#</cfif>">
				<input type="text"
					name="RHEECdescripcion#index#" id="RHEECdescripcion#index#"
					maxlength="5"
					size="#Attributes.size#"
					readonly 
					value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHEECdescripcion#index#")>#Evaluate('Attributes.query.RHEECdescripcion#index#')#</cfif>"
					<cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>tabindex="#Attributes.tabindex#"</cfif> >
					<a href="javascript: doConlis_relacioncap#index#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Relaciones de Capacitaci&oacute;n" name="imagen" width="18" height="14" border="0" align="absmiddle"></a>
			<cfelse>
				
				<cfquery name="data" datasource="#session.DSN#">
					select RHEECid, RHEECdescripcion
					from RHEEvaluacionCap
					where Ecodigo = #Session.Ecodigo#
					and RHEECestado in (#attributes.estado#)
				</cfquery>
				
				<select name="RHEECid#index#">
					<option value=""></option>
					<cfloop query="data">
						<option value="#data.RHEECid#">#RHEECdescripcion#</option>
					</cfloop>
				</select>
			</cfif>				
		</td>
	</tr>
</table>
</cfoutput>