<cfif isdefined('url.Nuevo') or isdefined('form.Nuevo')>
	<cfset form.modo='Alta'>
</cfif>

<cfparam name="form.id_datos" default="">
<cfparam name="form.tipo" default="">
<cfif isdefined("form.MIGMid") and len(trim(form.MIGMid))>
	<cfquery name="rsTipo" datasource="#session.DSN#">
		select MIGMdetalleid,MIGMtipodetalle
		from MIGFiltrosmetricas  
		where MIGMid = #form.MIGMid#
	</cfquery>
	<cfoutput>
	 <table cellpadding="0" cellspacing="0" border="0">
	 	<tr><td>	
		 <cfform enctype="multipart/form-data" name="FORMFILTROS" id="FORMFILTROS" method="post" action="MetricasSQL.cfm" style="margin:0">
		 <cfinput name="MIGMid" value="#form.MIGMid#" id="MIGMid"  type="hidden">
		 <cfinput name="id_datos" value="#form.id_datos#" id="id_datos"  type="hidden">
		 <cfinput name="rfiltro" value="#rsTipo.MIGMtipodetalle#" id="rfiltro"  type="hidden">
		 <cfinput name="valsIn" value="" id="valsIn"  type="hidden">
		 <cfinput name="valsOut" value="" id="valsOut"  type="hidden">
		 </CFFORM>
		 <cfdiv id="divListas" onbinderror="myerror" bind="url:FDatosFiltrosList.cfm?tipo={FORMFILTROS:rfiltro}&MIGMid={FORMFILTROS:MIGMid}&id_datos={FORMFILTROS:id_datos}&modo=#form.modo#"/>
		</td></tr>
	</table>
	
	<script>
		function myerror(){}
		
		function funcBTNSubmit(fd,fsel){
			var sel1 =  fd;
			var sel2 = fsel;
			
			var dvalsIn = "";
			for(var i=(sel2.options.length - 1);i>=0;i--){
				if(dvalsIn != ''){	
					dvalsIn = dvalsIn + ',' + sel2.options[i].value;
				}
				else{dvalsIn = sel2.options[i].value;}		
			}
			document.getElementById('valsIn').value = dvalsIn;
			
			var dvalsOut = "";	
			for(var i=(sel1.options.length - 1);i>=0;i--){
				if(dvalsOut != ''){	
					dvalsOut = dvalsOut + ',' + sel1.options[i].value;
				}
				else{dvalsOut = sel1.options[i].value;}		
			}
			document.getElementById('valsOut').value = dvalsOut;  
			document.FORMFILTROS.submit()	
		}
	
		function addDepto(){
			
			var sel1 =  document.getElementById('Flista');
			var sel2 = document.getElementById('Fselected');
	
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
		function delDepto(){
			var sel1 =  document.getElementById('Flista');
			var sel2 = document.getElementById('Fselected');
	
			for(var i=(sel2.options.length - 1);i>=0;i--){
			 if(sel2.options[i].selected)
				{
					sel1[sel1.length] = new Option(sel2.options[i].text);
					sel1[sel1.length-1].value = sel2.options[i].value;
					sel2.options[i] = null;
				}
			}   		
		}
		function retornarDetalleid(detalleid)
		{	//alert(detalleid)
			document.formDatos.MIGMdetalleid.value = detalleid;
		}
		function retornarDetalleDepto(Dcodigo)
		{ //alert(Dcodigo)
			document.formDatos.Dcodigo.value = Dcodigo;
		}
		
	</script>
	
	</cfoutput>
	
<cfelse>
	<center>Debe Crear Metricas</center>
	<cfabort>
</cfif>