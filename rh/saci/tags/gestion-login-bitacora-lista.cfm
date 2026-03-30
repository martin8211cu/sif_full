 	<cfquery name="rsBLautomatica" datasource="#session.DSN#">
		select '-1' as value
				, '--Todas--' as description
		union
			Select 	
				 '0' as value
				, 'Manual' as description								
		union 		
			Select '1' as value
				, 'Automática' as description
		order by value
	</cfquery>
 
	<cfinvoke component="sif.Componentes.pListas" method="pLista"
		tabla="ISBbitacoraLogin"
		columnas="BLid
				, LGlogin
				, BLfecha
				, BLfecha as BLhora
				, BLobs
				, BLusuario
				, case BLautomatica
					when 0 then 'Manual'
					when 1 then 'Automática'
				end BLautomatica
				, 0 as pintaBotones"
		filtro=" LGnumero = #form.LGnumero#
				order by BLfecha desc"
		desplegar="BLfecha,BLhora,BLobs,BLusuario,BLautomatica"
		rsBLautomatica="#rsBLautomatica#"		
		etiquetas="Fecha,Hora,Observaciones,Usuario,Tipo"
		formatos="D,H,S,S,U"
		align="left,left,left,left,center"
		funcion="Selecciona"
		fparams="BLid"
		ira="gestion.cfm"
		incluyeForm="false"
		formName="form1"
		showLink="true"
		keys="BLid"
		maxRows="20"
		mostrar_filtro="yes"
		filtrar_por="BLfecha,BLhora,BLobs,BLusuario,BLautomatica"
		filtrar_automatico="yes"
	/>
	
	<cfoutput>	
		<script language="javascript" type="text/javascript">
			var popUpWin=0; 
			function popUpWindow(URLStr, left, top, width, height){
			  if(popUpWin){
				if(!popUpWin.closed) popUpWin.close();
			  }
			  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=yes,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			}
			function Selecciona(param){
				popUpWindow("/cfmx/saci/consultas/actividades/detalleActiv.cfm?tipo=1&llave=" + param,200,100,700,300);
				return false;
			}
			function funcFiltrar(){
				document.form1.PINTABOTONES.value=0;
				return true;
			}
			
			document.form1.filtro_BLhora.style.display='none';
		</script>	
	</cfoutput>	