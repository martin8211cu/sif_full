 <cfparam name="form.tipo" default="">
 

<cfquery name="rsTipo" datasource="#session.DSN#">
	select MIGMtipodetalle
	from MIGMetricas 
	where MIGMid = #form.MIGMID#
</cfquery>
 
 <cfquery name="rsMod" datasource="#session.DSN#">
	select count(1) as si
	from F_Resumen 
	where MIGMid = #form.MIGMID#
</cfquery>

 
<cfoutput>
 <cfform enctype="multipart/form-data" name="FORMFILTROS" id="FORMFILTROS" method="post" action="MetricasSQL.cfm">
 <cfinput name="pagenum1" value="#pagenum#" id="pagenum1"  type="hidden">
 <cfinput name="MIGMID" value="#form.MIGMID#" id="MIGMID"  type="hidden">
 <cfinput name="modificable" value="#rsMod.si#" id="modificable"  type="hidden">
 <cfinput type="hidden" name="pagenum" id="pagenum" value="<cfoutput>#pagenum#</cfoutput>">
 <cfif rsMod.si gt 0>
 		<cfif rsTipo.MIGMtipodetalle EQ 'D'>DEPARTAMENTO</cfif>
		<cfif rsTipo.MIGMtipodetalle EQ 'C'>CUENTA</cfif>
		<cfif rsTipo.MIGMtipodetalle EQ 'P'>PRODUCTO</cfif>(No modificable existen datos calculados)
		<input name="rfiltro" type="hidden" value="<cfif isdefined("rsTipo.MIGMtipodetalle") and len(trim(rsTipo.MIGMtipodetalle))>#rsTipo.MIGMtipodetalle#<cfelse>D</cfif>">
 <cfelse>
	 <cfselect name="rfiltro" id="rfiltro">
		<option value="D" <cfif rsTipo.MIGMtipodetalle EQ 'D'>selected="selected"</cfif>>DEPARTAMENTO</option>
		<option value="C" <cfif rsTipo.MIGMtipodetalle EQ 'C'>selected="selected"</cfif>>CUENTA</option>
		<option value="P" <cfif rsTipo.MIGMtipodetalle EQ 'P'>selected="selected"</cfif>>PRODUCTO</option>
	 </cfselect>
 </cfif>
 <cfinput name="valsIn" value="" id="valsIn"  type="hidden">
 <cfinput name="valsOut" value="" id="valsOut"  type="hidden">
 <cfparam name="tabChoice" default="1">
 <cfinput name="tab" value="#tabChoice#" id="tab"  type="hidden">
 
 </cfform>
<!--- <cfdiv id="divListas" onbinderror="myerror" bind="url:ListDeptos.cfm?tipo={FORMFILTROS:rfiltro}&MIGMID={FORMFILTROS:MIGMID}&MOD={FORMFILTROS:modificable}"/>--->
 <cfdiv id="divListas" onbinderror="myerror" bind="url:MetricaListDetalles.cfm?tipo={FORMFILTROS:rfiltro}&MIGMID={FORMFILTROS:MIGMID}&MOD={FORMFILTROS:modificable}"/>
<script>
	function myerror(){}
	
	function refreshFiltros(){
			 var httpParams = {
				suppresslayout:1,
				tipo:document.getElementById("rfiltro").value
			};
			var qryString = $H(httpParams).toQueryString();

			new Ajax.Updater("divListas","ListDeptos.cfm",
				{parameters:qryString,method:"get",evalScripts:true,onComplete:function(){Effect.Highlight("divListas",{queue:"end"});}
			});
	}
	
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
		var sel1 =  document.formMetr.Flista;
		var sel2 = document.formMetr.Fselected;
		var count = 0;
		var err = '';
		
		for(var i=(sel1.options.length - 1);i>=0;i--){
		 if(sel1.options[i].selected)
		   	count = count + 1
		}
		
		if(count > 1){
			err = 'Solo puede seleccionar un detalle.'
		}
		if(sel2.options.length >= 1){
			err = 'Solo puede asignarse un detalle.'
		}
		
		if(err != ''){
			alert(err);
		}
		else{
			for(var i=(sel1.options.length - 1);i>=0;i--){
			 if(sel1.options[i].selected)
				{
					sel2[sel2.length] = new Option(sel1.options[i].text);
					sel2[sel2.length-1].value = sel1.options[i].value;
					sel1.options[i] = null;
				}
			}
		}  		
	}
	function delDepto(){
		var sel1 =  document.formMetr.Flista;
		var sel2 = document.formMetr.Fselected;

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