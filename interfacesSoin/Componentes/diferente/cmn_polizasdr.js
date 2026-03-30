//------------------------------------------------------------------------------------------------------
// SISTEMA		: CONTABILIDAD
// PANTALLA		: Polizas diarias
// CREADO		: HARE
// MODIFICADO	: INDIGO (16-MAYO-2001)
//------------------------------------------------------------------------------------------------------
var datos = document.forms[0] // datos.
var valor=""
var valor2=""

if(datos.MODO.value=="CAMBIO") 
{
	traeCONCEPTO()
   	valor = datos.CTBAUX.checked
   	valor2 = datos.CTBRAC.checked
	DETALLE()
} else {

}

//------------------------------------------------------------------------------------------------------
function AJUSTAR()
{
	var  hilera = ''
  	hilera =top.frames['workspace'].frames[1].document.forms[0].D1.value
	if (hilera!='') 
	{
    	if(confirm('Esta seguro que desea ajustar?')) 
		{
			pos = hilera.indexOf("CTDLIN")
			hilera= hilera.substring(pos, hilera.length - 1)
			pos = hilera.indexOf("&")
			hilera= hilera.substring(1, pos)
			pos = hilera.indexOf("=")
			hilera= hilera.substring(pos+1, hilera.length)
			
			sql = 'cmn_cuadra_asiento_local'
			sql=  sql + ' @CG5CON=' +  datos.CG5CON.value
			sql=  sql + ',@CTBCOD=' +datos.CTBCOD.value
			sql=  sql + ',@CTBPER=' +datos.PERCOD.value
			sql=  sql + ',@CTBMES=' +datos.MESCOD.value
			sql=  sql + ',@CTDLIN=' + hilera
			
      		if (executeSP(sql , "0"))
			{
				alert('Póliza ajustada')
				location.reload()
				top.frames['workspace'].frames['workspace2'].location.reload()
				top.frames['workspace'].frames['workspace3'].location.reload()
			}
		}
	}
 	else 
  		alert('Debe seleccionar una linea')
}
//------------------------------------------------------------------------------------------------------
function AJUSTARFIJAS()
{

	var  hilera = ''
  	hilera =top.frames['workspace'].frames[1].document.forms[0].D1.value
	if (hilera!='') 
	{
    	if(confirm('Esta seguro que desea ajustar?')) 
		{
			pos = hilera.indexOf("CTDLIN")
			hilera= hilera.substring(pos, hilera.length - 1)
			pos = hilera.indexOf("&")
			hilera= hilera.substring(1, pos)
			pos = hilera.indexOf("=")
			hilera= hilera.substring(pos+1, hilera.length)
			
			sql = 'cmn_BalAsiFij'
			sql=  sql + ' @CG5CON=' +  datos.CG5CON.value
			sql=  sql + ',@CTBCOD=' +datos.CTBCOD.value
			sql=  sql + ',@CTDLIN=' + hilera
			
      		if (executeSP(sql , "0"))
			{
				alert('Póliza ajustada')
				location.reload()
				top.frames['workspace'].frames['workspace2'].location.reload()
				top.frames['workspace'].frames['workspace3'].location.reload()
			}
		}
	}
 	else 
  		alert('Debe seleccionar una linea')

}
//------------------------------------------------------------------------------------------------------
function ElIMINAR(){
	if (!datos.CTBAUX.checked){
		open("soin.sif.cmn.cmn_borradolin?CTBPER="+formatURL(datos.PERCOD.value)
			+"&CTBMES="+formatURL(datos.MESCOD.value)
			+"&CG5CON="+formatURL(datos.CG5CON.value)
			+"&CTBCOD="+formatURL(datos.CTBCOD.value),'','left=50,top=50,scrollbars=yes,resizable=yes,width=860,height=560')
	}
	else{
		alert("La eliminación de líneas no es válida para pólizas provenientes de auxiliares")
	}
} 
//------------------------------------------------------------------------------------------------------

function POSTEAR() 
{
	var SQL=""
	if(datos.RETRO.value=='N') //DIARIAS
	{
		if(confirm('Esta seguro que desea postear?')) 
		{
			SQL+="exec sp_Aplicar "
			SQL+="@CG5CON="+datos.CG5CON.value
			SQL+=",@asiento="+datos.CTBCOD.value
			SQL+=",@periodo="+datos.PERCOD.value
			SQL+=",@mes="+datos.MESCOD.value
			SQL+=",@masiva=0" 
			SQL+=",@usuario="+scm(datos.USUARIO.value)
			if(executeSP(SQL,0)) 
			{
				alert('Poliza posteada con éxito')
				CANCELAR()
			}
			else
			{
				location.reload()
        		top.frames['workspace'].frames['workspace2'].location.reload()
        		top.frames['workspace'].frames['workspace3'].location.reload()
			}
		}
	}
	
	if(datos.RETRO.value=='S') //RETROACTIVAS
	{
   		if(confirm('Esta seguro que desea postear?')) 
		{
			SQL=""
			SQL+="exec sp_Aplicar_Retroactivo "
			SQL+="@CG5CON="+datos.CG5CON.value
			SQL+=",@asiento="+datos.CTBCOD.value
			SQL+=",@periodo="+datos.PERCOD.value
			SQL+=",@mes="+datos.MESCOD.value
			SQL+=",@usuario="+datos.USUARIO.value
			
			if(executeSP(SQL,0)) 
			{
				alert('Poliza posteada con éxito')  
				CANCELAR()   
			}
			else 
			{
				location.reload()
				top.frames['workspace'].frames['workspace2'].location.reload()
				top.frames['workspace'].frames['workspace3'].location.reload()
			}
		}
	}
	
	if(datos.RETRO.value=='F') //FIJAS 
  	{
   		SQL=""
		if(confirm('Esta seguro que desea postear?')) 
		{
			SQL+="exec sp_AplicarFijo "
			SQL+="@CG5CON="+datos.CG5CON.value
			SQL+=",@CTBCOD="+datos.CTBCOD.value
			if(executeSP(SQL,0)) 
			{
				alert('Poliza posteada con éxito')  
				CANCELAR() 
			}  
			else 
			{
				location.reload()
				top.frames['workspace'].frames['workspace2'].location.reload()
				top.frames['workspace'].frames['workspace3'].location.reload()
			}
		}
	}
}
//------------------------------------------------------------------------------------------------------
function chequear() 
{
	if(valor)
		datos.CTBAUX.checked=true
	else
		datos.CTBAUX.checked=false
datos.CTBAUX.blur() 
}
//------------------------------------------------------------------------------------------------------
function chequear2() 
{
	if(valor2)
		datos.CTBRAC.checked=true
	else
		datos.CTBRAC.checked=false
datos.CTBRAC.blur() 
}
//------------------------------------------------------------------------------------------------------
function valida()
{
	if(datos.PERCOD.value==""){alert('Debe digitar el periodo'); datos.PERCOD.focus(); return false;}  
	if(datos.MESCOD.value==""){alert('Debe digitar el mes'); datos.MESCOD.focus(); return false;}  
	if(datos.CG5CON.value==""){alert('Debe digitar el concepto de poliza'); datos.CG5CON.focus(); return false;}  
	if(datos.CTBEST.value==""){alert('Debe digitar el estado'); datos.CTBEST.focus(); return false;}  
	if(datos.CTBDES.value==""){alert('Debe digitar la descripción'); datos.CTBDES.focus(); return false;}  
	if(datos.RETRO.value=='S' ||  datos.RETRO.value=='N') 
		if(datos.CTBFEC.value==""){alert('Debe digitar la fecha del asiento'); datos.CTBFEC.focus(); return false;}  
	return true
}
//------------------------------------------------------------------------------------------------------
function sp(action) 
{
	var tabla=""
	var SQL=""
	if(valida()) 
	{
    	if(datos.RETRO.value=='S' ||  datos.RETRO.value=='N')
       		tabla="CGX002"
     	else
        	tabla="CGX004"

		SQL+="exec sp_"+action+"_"+tabla
		SQL+=" @CTBPER="+sen(datos.PERCOD.value)
		SQL+=",@CTBMES="+sen(datos.MESCOD.value)
		SQL+=",@CG5CON="+sen(datos.CG5CON.value)
		
		if(datos.MODO.value=='ALTA')
        	SQL+=",@CTBCOD=null"
		else
        	SQL+=",@CTBCOD="+sen(datos.CTBCOD.value)
			
		if(datos.MODO.value=='ALTA') 
		{
        	SQL+=",@CTBCRE=0"
	        SQL+=",@CTBDEB=0"
    	} 
	    else 
		{
        	SQL+=",@CTBCRE="+qf(datos.CTBCRE.value)
	        SQL+=",@CTBDEB="+qf(datos.CTBDEB.value)
    	}

		SQL+=",@CTBEST="+scm(datos.CTBEST.value)
		SQL+=",@CTBLIN=0"
		SQL+=",@CTBDES="+scm(datos.CTBDES.value)
		SQL+=",@CTBMOD='N'"

		if(datos.RETRO.value=='S' ||  datos.RETRO.value=='N') 
			SQL+=",@CTBFEC="+scm(sd(datos.CTBFEC.value))

		SQL+=",@CTBUSR="+scm(datos.LOGIN.value)
		if(datos.RETRO.value=='S' ||  datos.RETRO.value=='N')
        	SQL+=",@PERCOD=null"
    
		if(datos.RETRO.value=='N' || datos.RETRO.value=='F')
			SQL+=",@CTBRET='N'"
	    else
    		SQL+=",@CTBRET='S'"

		SQL+=",@CRPPER="+sen(datos.PERCOD.value)
		SQL+=",@CRPMES="+sen(datos.MESCOD.value)
		if(datos.RETRO.value=='N' || datos.RETRO.value=='S') 
		{
	        SQL+=",@ES1COD=null"
    	    SQL+=",@CTBAPL=null"
		}
		
		if(datos.MODO.value=='CAMBIO')
			SQL+=",@timestamp="+datos.timestamp.value
        
		SQL+=",@CTBAUX='N'"
     	if(datos.RETRO.value=='S')
			SQL+=",@CTBRAC=0"
		if(datos.RETRO.value=='N') 
		{
			if(datos.CTBRAC.checked)
				SQL+=",@CTBRAC=1"
			else
				SQL+=",@CTBRAC=0"
		}
		
		SQL+=",@HIPCON=null"
		SQL+=",@CTBHOY="+scm(sd(datos.CTBHOY.value))
		
		if(action=='Alta') 
		{
			var LLAVE = execSP(SQL)
			if(ESNUMERO(LLAVE)) 
			{
				//CANCELAR() Todo ok
				top.frames['workspace'].location.href="/servlet/soin.sif.cmn.cmn_Frame?MODO=CAMBIO&RETRO="+formatURL(datos.RETRO.value)
				+"&CG5CON="+formatURL(datos.CG5CON.value)+"&CTBCOD="+formatURL(LLAVE)+"&CTBPER="+formatURL(datos.PERCOD.value)
				+"&CTBMES="+formatURL(datos.MESCOD.value)
			}
			else
				alert(LLAVE) //Ocurrio un error
			}
		else 
		{
			if(executeSP(SQL,0)) 
			{
				if(action=='Cambio')
					top.frames['workspace'].location.reload()
				else
					CANCELAR()
			}
		}
	} 
}
//------------------------------------------------------------------------------------------------------
function ACEPTAR() 
{
	if(datos.MODO.value=='ALTA') 
		sp('Alta')
	else
		sp('Cambio')
}
//------------------------------------------------------------------------------------------------------
function VERTOTALES()
{
	top.frames['workspace'].frames['workspace3'].location.href="soin.sif.cmn.cmn_totalesdc?MODO=ALTA&CG5CON="+formatURL(datos.CG5CON.value)
	+"&CTBCOD="+formatURL(datos.CTBCOD.value)+"&CTBPER="+formatURL(datos.PERCOD.value)+"&CTBMES="+formatURL(datos.MESCOD.value)
}
//------------------------------------------------------------------------------------------------------
function DETALLE() 
{
	var chek =""
	var fecha =''

	if(datos.CTBAUX.checked)
		chek='S'
	else
		chek='N'

	if(datos.RETRO.value=="S" || datos.RETRO.value=="N")
	{
		tabla="CGX003"
		fecha= datos.CTBFEC.value
	}
	else
	{
    	tabla="CGX005"
		fecha= datos.CTBHOY.value
	}

	var  URL3="soin.sif.cmn.cmn_totalesdc?MODO=ALTA&CG5CON="+formatURL(datos.CG5CON.value)+"&CTBCOD="+formatURL(datos.CTBCOD.value)
	+"&CTBPER="+formatURL(datos.PERCOD.value)+"&CTBMES="+formatURL(datos.MESCOD.value)+"&RETRO="+formatURL(datos.RETRO.value)
	+"&TABLA="+formatURL(tabla)
	
	top.frames['workspace'].frames[2].location.href=URL3

	var campox=""
	campox="&campos="+formatURL("CTDLIN,CGM1IM,CGM1CD,DEBITOS=case when CTDTIP='D' then CTDMON  end,"
	+" CREDITOS=case when CTDTIP='C' then CTDMON  end,CTBCOD,CG5CON,MONCOD,CTBPER,CTBMES,CGM1ID,RETRO='"+datos.RETRO.value+"', "
   	+" EXTD=case when CTDTIP='D' then CTDMOE  end,EXTC=case when CTDTIP='C' then CTDMOE   end,"
   	+" CTACAM=CTACAM,CGE5COD,FECHA='"+fecha
	+"',LOGIN='"+datos.LOGIN.value+"',CTBAUX='"+chek+"'")

	var URL2="MSelnav?"
	URL2+="filtro="+formatURL("CTBPER="+datos.PERCOD.value+" and CTBMES="+datos.MESCOD.value+" and CG5CON="+datos.CG5CON.value+" and CTBCOD="+datos.CTBCOD.value)
	URL2+="&llaves="+formatURL("CG5CON,CTBCOD,CTBPER,CTBMES,FECHA,LOGIN,CTBAUX,RETRO")
	URL2+=	"&tipo=L&tabla="+tabla
	URL2+=	campox
	URL2+=	"&pkey=CTDLIN"
	URL2+=	"&size="+formatURL("5,4,20,18,18,6,18,18,11,11")
	URL2+=	"&mostrar="+formatURL("CTDLIN,CGM1IM,CGM1CD,DEBITOS,CREDITOS,MONCOD,EXTD,EXTC,CTACAM,CGE5COD")
	URL2+=	"&titulos="+formatURL("Lin,May,Detalle,Debe(L),Haber(L),Moneda,Debe(ex),Haber(ex),Tasa cambio,Sucursal")
	URL2+=	"&vllaves="+formatURL(datos.CG5CON.value+","+datos.CTBCOD.value+","+datos.PERCOD.value+","+datos.MESCOD.value+","+fecha+","+datos.LOGIN.value+","+chek+","+datos.RETRO.value)
	URL2+=	"&mansab="+formatURL("soin.sif.cmn.cmn_detpolizasdr")+"&target="+formatURL("top.frames[2].frames[0].location.href")	

    top.frames['workspace'].frames[1].location.href=URL2
}
//------------------------------------------------------------------------------------------------------
function DETALLE2() 
{	
	var  URL3="soin.sif.cmn.cmn_totalesdc?MODO=ALTA&CG5CON="+formatURL(datos.CG5CON.value)+"&CTBCOD="+formatURL(datos.CTBCOD.value)
	+"&CTBPER="+formatURL(datos.PERCOD.value)+"&CTBMES="+formatURL(datos.MESCOD.value)+"&RETRO="+formatURL(datos.RETRO.value)

	top.frames['workspace'].frames['workspace3'].location.href=URL3
}
//------------------------------------------------------------------------------------------------------
function BUSCAR()
{
	var tablax=""
	if(datos.RETRO.value=='S' ||  datos.RETRO.value=='N')
		tablax="CGX002"
	else
    	tablax="CGX004"
		
	var tabla="tabla="		+ formatURL(tablax)
	var campos="&campos="	+ formatURL("CG5CON,CTBCOD,CTBPER,CTBMES,CTBEST,CTBDES,RETRO='"+datos.RETRO.value+"',CTBUSR")
	var tipos="&tipos="		+ formatURL("N,N,N,N,S,S,S")
	var size="&size="		+ formatURL("6,8,7,3,6,40,15")
	var mostrar="&mostrar=" + formatURL("CG5CON,CTBCOD,CTBPER,CTBMES,CTBEST,CTBDES,CTBUSR")
	var titulos="&titulos=" + formatURL("Lote,Asiento,Periodo,Mes,Estado,Descripción,Usuario")
	var filtro="&filtro="
	var aux=""
	var filtro2="&filtro2=" + formatURL(" CTBUSR='"+datos.LOGIN.value+"'")
		
	if(datos.RETRO.value=='S' ||  datos.RETRO.value=='N') 
	{
		if(datos.RETRO.value=='S' || datos.RETRO.value=='s')
			filtro +=  formatURL("upper(CTBRET) = 'S'")
		else
			filtro +=  formatURL("upper(isnull(CTBRET, 'N')) <> 'S'")
	}
	
	 if(datos.RETRO.value=='S' ||  datos.RETRO.value=='N') 
   		if (datos.CG5CON.value !='') {filtro += formatURL(" and CG5CON >= " + datos.CG5CON.value)}
	 if(datos.RETRO.value=='F') 
     	if (datos.CG5CON.value !='') {filtro += formatURL(" CG5CON >= " + datos.CG5CON.value)}

	switch(datos.RETRO.value)
	{
		case "N": var tfrase="&tfrase=" + formatURL("Polizas Diarias")
				  break;
		case "S": var tfrase="&tfrase=" + formatURL("Polizas Retroactivas")
				  break;		
		case "F": var tfrase="&tfrase=" + formatURL("Polizas Fijas")
				  break;		
	} 
	
	var mansab="&mansab=" + formatURL("soin.sif.cmn.cmn_Frame")
	var cargar="&cargar=" + formatURL("N")
	//var llaves="&llaves="
	//var vllaves="&vllaves="
	var pllaves="&pkey="+ formatURL("CG5CON")
	var tam="&tam=" + formatURL("26")
	var params = tabla+campos+tipos+size+mostrar+titulos+filtro+tfrase+mansab+tam+filtro2+pllaves+cargar
	
	top.frames['workspace'].location.href="MSelnav?" + params
}
//------------------------------------------------------------------------------------------------------
function BORRAR(){if(confirm('Esta seguro que desea borrar?')){sp('Baja')}}
//------------------------------------------------------------------------------------------------------
function CANCELAR(){top.frames['workspace'].location.href="soin.sif.cmn.cmn_polizasdr?MODO=ALTA&RETRO="+formatURL(datos.RETRO.value)}
//------------------------------------------------------------------------------------------------------
function conlisCONCEPTO(){

   var campos = "campos="+ formatURL("CG5CON,CG5DES")
   var asigna = "&asigna=" + formatURL("datos.CG5CON=CG5CON,datos.CG5DES=CG5DES")
   //var tipos = "&tipos=" + formatURL("S,S")
   var titulo = "&titulo=" + formatURL("Concepto de Póliza")
   var tabla = "&tabla=" + formatURL("CGM005")
   var mostrar = "&mostrar=" + formatURL("CG5CON,CG5DES")
   var filtro =  "&filtro=" + formatURL("CG5ACT=0 and CG5VEC = 1")
   var titulos = "&titulos=" + formatURL("Concepto inicial,Descripción")
   
   var params = campos + asigna + titulo + tabla + mostrar + filtro + titulos

   open("clConlis?" + params,"","left=580,top=320,scrollbars=yes,resizable=yes,width=325,height=275")

}
//------------------------------------------------------------------------------------------------------
function traeCONCEPTO() 
{
	if(datos.CG5CON.value!='') 
	{
		var consulta="select CG5DES from CGM005 where CG5CON="+datos.CG5CON.value
		var valores = new Array(datos.CG5DES)
		getDescription(consulta,datos.CG5CON,valores,"yes")
	}
	else
	{
		clean(datos.CG5CON);clean(datos.CG5DES)
	} 
}
//------------------------------------------------------------------------------------------------------
function LIMPIAR() 
{
	clean(datos.CG5CON)
	clean(datos.CG5DES)
	clean(datos.PERCOD)
	clean(datos.MESCOD)
	if(datos.RETRO.value=='S' || datos.RETRO.value=='N')
	clean(datos.CTBFEC)	
	clean(datos.CTBEST)
	clean(datos.CTBDES)
}
//------------------------------------------------------------------------------------------------------
