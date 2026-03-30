<cfparam name="form.tipo" default="">

<cfquery name="rsTipo" datasource="#session.DSN#">
	select MIGMtipodetalle, MIGMescorporativo,Ecodigo
	from MIGMetricas
	where MIGMid = #form.MIGMID#
</cfquery>

 <cfquery name="rsMod" datasource="#session.DSN#">
	select count(1) as si
	from F_Resumen
	where MIGMid = #form.MIGMID#
</cfquery>

<cfoutput>

 <cfform enctype="multipart/form-data" name="FormFiltrosMetricas" id="FormFiltrosMetricas" method="post" action="IndicadoresSQL.cfm" onSubmit="return valida(this);">

 	<input type="hidden" name="BajaFiltrosIndicadores" id="BajaFiltrosIndicadores" value="false">
 	<input type="hidden" name="MIGMdetalleid" id="MIGMdetalleid" value="">
	<input type="hidden" name="MIGMidPadre" id="MIGMidPadre" value="">
	<input type="hidden" name="MIGMidHijo" id="MIGMidHijo" value="">
	<input type="hidden" name="pagenum1" id="pagenum1" value="#pagenum#">

	 <cfinput name="MIGMID"      value="#form.MIGMID#" id="MIGMID"       type="hidden">
	 <cfinput name="modificable" value="#rsMod.si#"    id="modificable"  type="hidden">

	 <strong>Métricas:</strong>

	 <cfif isdefined('rsTipo.MIGMescorporativo') and rsTipo.MIGMescorporativo EQ 1>
	 	<cfset filtro =  "CEcodigo=#session.CEcodigo#  order by MIGMcodigo, MIGMnombre">
	 <cfelse>
	 	<cfset filtro =  "Ecodigo=#session.Ecodigo# and CEcodigo=#session.CEcodigo#  order by MIGMcodigo, MIGMnombre">
	 </cfif>
	 <!---PODEMOS AGREGAR LA EMPRESA PARA UNA MEJOR DESCRIPCION--->
	 <cf_conlis title="Lista de Metricas"
			campos = "MIGMidindicador , MIGMcodigo, MIGMnombre"
			desplegables = "N,S,S"
			modificables = "N,S,N"
			tabla="MIGMetricas"
			columnas="MIGMid as MIGMidindicador, MIGMcodigo, MIGMnombre"
			filtro="#filtro#"
			desplegar="MIGMcodigo, MIGMnombre"
			etiquetas="Codigo,Metrica"
			formatos="S,S"
			align="left,left"
			size="0,20,60"
			filtrar_por="MIGMcodigo, MIGMnombre"
			tabindex="1"
			form="FormFiltrosMetricas"
			funcion="refreshThis"
			/> <br />

	<strong>Filtrar por:</strong><br>

	 <cfselect name="rfiltro" id="rfiltro">
		<option value="D">DEPARTAMENTO</option>
		<option value="C">CUENTA</option>
		<option value="P">PRODUCTO</option>
	 </cfselect>

	 <cfinput name="sub_MIGMid" value="" id="sub_MIGMid"  type="hidden">
	 <cfinput name="valsInInd" value="" id="valsInInd"  type="hidden">
	 <cfinput name="valsOutInd" value="" id="valsOutInd"  type="hidden">
	 <cfparam name="tabChoice" default="1">
 	 <cfinput name="tab" value="#tabChoice#" id="tab"  type="hidden">
 </cfform>

 <cfdiv id="divListasInd" onbinderror="myerror" bind="url:indicadoresListDeptos.cfm?tipo={FormFiltrosMetricas:rfiltro}&MIGMID={FormFiltrosMetricas:MIGMID}&MOD={FormFiltrosMetricas:modificable}&sub_MIGMid={FormFiltrosMetricas:sub_MIGMid}"/>

<!---inicio--->
<cfoutput>
<cfquery datasource="#session.DSN#" name="rsMetricas">
	select distinct c.MIGMid,c.MIGMnombre,c.MIGMcodigo,a.MIGMtipodetalle
	from MIGFiltrosindicadores a
		inner join MIGMetricas c
		on c.MIGMid = a.MIGMid
		<!---and c.Ecodigo = a.Ecodigo--->

	where a.MIGMidindicador = #form.MIGMID#
	and a.Ecodigo = #session.Ecodigo#
	order by c.MIGMcodigo
</cfquery>
<table align="center" border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>

		<td valign="top" width="20">
			<strong>Codigo</strong>
		</td>
		<td valign="top" width="150">
			<strong>Descripcion</strong>
		</td>
		<td valign="top" width="60">
			<strong>Tipo</strong>
		</td>
		<td width="150">
			<strong>Detalles</strong>
		</td>
	</tr>
	<cfloop query="rsMetricas">
		<cfset MIGMid_actual = rsMetricas.MIGMid>
		<cfset MIGMcodigo_actual = rsMetricas.MIGMcodigo>
		<cfset MIGMnombre_actual = rsMetricas.MIGMnombre>
		<cfset tipodetalle = rsMetricas.MIGMtipodetalle>

			<cfif tipodetalle is 'D'>
				<cfquery datasource="#session.DSN#" name="rsDatosSelect">
					select a.MIGMdetalleid as id, b.Deptocodigo as codigo,b.Ddescripcion as descripcion,c.MIGMnombre
					from MIGFiltrosindicadores a

						inner join MIGMetricas c	<!---No debe haber relacion con Ecodigo por que pueden ser diferentes Empresas en el caso de los indicadores coorporativos--->
						on c.MIGMid = a.MIGMid

						inner join Departamentos b	<!---La metrica debe relacionarse con su Departamento en su Empresa--->
						on b.Dcodigo = a.MIGMdetalleid
						and b.Ecodigo = c.Ecodigo

					where MIGMidindicador = #form.MIGMID#
					and a.MIGMid = #MIGMid_actual#
					and a.Ecodigo = #session.Ecodigo#
				</cfquery>

			<cfset listaDetalleIds= valuelist(rsDatosSelect.id)>

			<cfelseif tipodetalle is 'C'>
				<cfquery datasource="#session.DSN#" name="rsDatosSelect">
					select a.MIGMdetalleid as id, b.MIGCuecodigo as codigo,b.MIGCuedescripcion as descripcion,c.MIGMnombre
					from MIGFiltrosindicadores a
						inner join MIGCuentas b
						on b.MIGCueid = a.MIGMdetalleid
						and a.Ecodigo = b.Ecodigo

						inner join MIGMetricas c
						on c.MIGMid = a.MIGMid
						and c.Ecodigo = a.Ecodigo

					where a.MIGMidindicador = #form.MIGMID#
					and a.MIGMid = #MIGMid_actual#
					and a.Ecodigo = #session.Ecodigo#
				</cfquery>
				<cfset listaDetalleIds= valuelist(rsDatosSelect.id)>
			<cfelseif tipodetalle is 'P'>
				<cfquery datasource="#session.DSN#" name="rsDatosSelect">
					select a.MIGMdetalleid as id, b.MIGProcodigo as codigo,b.MIGPronombre as descripcion,c.MIGMnombre
					from MIGFiltrosindicadores a
						inner join MIGProductos b
						on b.MIGProid = a.MIGMdetalleid
						and a.Ecodigo = b.Ecodigo

					inner join MIGMetricas c
						on c.MIGMid = a.MIGMid
						and c.Ecodigo = a.Ecodigo

					where MIGMidindicador = #form.MIGMID#
					and a.MIGMid = #MIGMid_actual#
					and a.Ecodigo = #session.Ecodigo#
				</cfquery>
				<cfset listaDetalleIds= valuelist(rsDatosSelect.id)>
			</cfif>
		<tr>

			<td valign="top" width="20">
				#MIGMcodigo_actual#
			</td>
			<td valign="top" width="150">
				#MIGMnombre_actual#
			</td>
			<td valign="top" width="100">
				<cfif tipodetalle EQ 'D'>DEPARTAMENTO</cfif>
				<cfif tipodetalle EQ 'C'>CUENTA</cfif>
				<cfif tipodetalle EQ 'P'>PRODUCTO</cfif>
			</td>
			<td>
				<table align="left" border="0" width="100%">
					<cfloop query="rsDatosSelect">
						<tr><td width="200">#rsDatosSelect.codigo#-#rsDatosSelect.descripcion#</td>
						<td><img src="../imagenes/Borrar01_S.gif" onclick="javascript: BorrarDetalle(#form.MIGMID#,#rsDatosSelect.id#,#MIGMid_actual#)"/></td>
						</tr>
					</cfloop>
				</table>
			</td>
		</tr>

	</cfloop>
	</table>
<script>

	function refreshThis(){
		var sub_MIGMid=document.FormFiltrosMetricas.MIGMidindicador.value;
		document.getElementById('sub_MIGMid').value = sub_MIGMid;
		var tipo=document.FormFiltrosMetricas.rfiltro.value;
		//alert('indicadoresListDeptos.cfm?tipo='+tipo+'&MIGMID=#form.MIGMid#&MOD=#rsMod.si#&sub_MIGMid=' + sub_MIGMid)
		ColdFusion.navigate('indicadoresListDeptos.cfm?tipo='+tipo+'&MIGMID=#form.MIGMid#&MOD=#rsMod.si#&sub_MIGMid=' + sub_MIGMid,'divListasInd'); <!---refresca el cfdiv--->
	}
	function BorrarDetalle(MIGMIDpadre,detalleId,MIGMidhijo){
		if(confirm('Esta seguro que desea borrar el detalle?')){
			document.getElementById('BajaFiltrosIndicadores').value = true;
 			document.getElementById('MIGMdetalleid').value = detalleId;
			document.getElementById('MIGMidPadre').value = MIGMIDpadre;
			document.getElementById('MIGMidHijo').value = MIGMidhijo;
			document.FormFiltrosMetricas.submit();
		}
	}
</script>
</cfoutput>
<!---fin--->

<script>

function valida(formulario)	{


		desp = document.form1.MIGMnombre.value;
		desp = desp.replace(/(^\s*)|(\s*$)/g,"");

		if (desp.length==0){
			error_msg += "\n - El nombre de Indicador no puede quedar en blanco.";
			error_input = formulario.MIGMnombre;
		}

		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
	function myerror(){}

	function funcBTNSubmitInd(fd,fsel){
		var sel1 =  fd;
		var sel2 = fsel;
		var dvalsIn = "";
		var msg  = '';

		if(document.FormFiltrosMetricas.MIGMidindicador.value == '') msg += '- El campo Métricas es Obligatorio\n';
		if(sel2.options.length == 0)msg += '- Debe seleccionar al menos un elemento de la lista\n';
		if(msg !=''){alert('Por favor revise los siguiente datos:\n'+msg);return false;}

		for(var i=(sel2.options.length - 1);i>=0;i--){
			if(dvalsIn != ''){
				dvalsIn = dvalsIn + ',' + sel2.options[i].value;
			}
			else{dvalsIn = sel2.options[i].value;}
		}
		document.FormFiltrosMetricas.valsInInd.value = dvalsIn;

		var dvalsOut = "";
		for(var i=(sel1.options.length - 1);i>=0;i--){
			if(dvalsOut != ''){
				dvalsOut = dvalsOut + ',' + sel1.options[i].value;
			}
			else{dvalsOut = sel1.options[i].value;}
		}
		document.FormFiltrosMetricas.valsOutInd.value = dvalsOut;
		document.FormFiltrosMetricas.submit()
	}

	function addDeptoInd(){

		var sel1 =  document.formInd.Flista;
		var sel2 = document.formInd.Fselected;

		for(var i=(sel1.options.length - 1);i>=0;i--){
		 if(
		 	sel1.options[i].selected)
		   	{
				sel2[sel2.length] = new Option(sel1.options[i].text);
				sel2[sel2.length-1].value = sel1.options[i].value;
				sel1.options[i] = null;
			}
		}
	}
	function delDeptoInd(){
		var sel1 =  document.formInd.Flista;
		var sel2 = document.formInd.Fselected;

		for(var i=(sel2.options.length - 1);i>=0;i--){
		 if(
		 	sel2.options[i].selected)
		   	{
				sel1[sel1.length] = new Option(sel2.options[i].text);
				sel1[sel1.length-1].value = sel2.options[i].value;
				sel2.options[i] = null;
			}
		}
	}
</script>
</cfoutput>