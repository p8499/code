package com.p8499.code;

import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.Enumeration;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.tomcat.util.http.fileupload.ByteArrayOutputStream;

@WebServlet(name="download",urlPatterns={"/download"})
public class DownloadServlet extends HttpServlet
{	private static final long serialVersionUID = 1L;
	public DownloadServlet()
	{	super();
	}
	@SuppressWarnings("unchecked")
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{	String dirName=this.getServletConfig().getServletContext().getRealPath("/"+System.currentTimeMillis());
		File dir=new File(dirName);
		dir.mkdirs();
		File dirJava=new File(dir,"java");
		dirJava.mkdir();
		File dirWeb=new File(dir,"web");
		dirWeb.mkdir();
		File dirAndroid=new File(dir,"android");
		dirAndroid.mkdir();
		Enumeration<String> attrNames=request.getServletContext().getAttributeNames();
		while(attrNames.hasMoreElements())
		{	String attrName=attrNames.nextElement();
			Object attr=request.getServletContext().getAttribute(attrName);
			if(attr instanceof Map)
			{	Map<String,Object> model=(Map<String,Object>)attr;
				
				File dirBean=new File(dirJava,(String)((Map<String,Object>)model.get("bean")).get("package"));
				dirBean.mkdir();
				String fileNameBean=(String)((Map<String,Object>)model.get("bean")).get("alias")+".java";
				createFile(dirBean,fileNameBean,request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/bean.jsp?model="+attrName);
				
				File dirMask=new File(dirJava,(String)((Map<String,Object>)model.get("bean")).get("maskPackage"));
				dirMask.mkdir();
				String fileNameMask=(String)((Map<String,Object>)model.get("bean")).get("maskAlias")+".java";
				createFile(dirMask,fileNameMask,request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/mask.jsp?model="+attrName);
				
				File dirListener=new File(dirJava,(String)((Map<String,Object>)model.get("bean")).get("listenerPackage"));
				dirListener.mkdir();
				String fileNameListener=(String)((Map<String,Object>)model.get("bean")).get("listenerAlias")+".java";
				createFile(dirListener,fileNameListener,request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/listener.jsp?model="+attrName);
				
				File dirMapper=new File(dirJava,(String)((Map<String,Object>)model.get("mapper")).get("package"));
				dirMapper.mkdir();
				String fileNameMapper=(String)((Map<String,Object>)model.get("mapper")).get("alias")+".java";
				createFile(dirMapper,fileNameMapper,request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/mapper.jsp?model="+attrName);
				
				File dirController=new File(dirJava,(String)((Map<String,Object>)model.get("controller")).get("package"));
				dirController.mkdir();
				String fileNameController=(String)((Map<String,Object>)model.get("controller")).get("alias")+".java";
				createFile(dirController,fileNameController,request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/controller.jsp?model="+attrName);
				String fileNameMaskController=(String)((Map<String,Object>)model.get("controller")).get("maskAlias")+".java";
				createFile(dirController,fileNameMaskController,request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/maskcontroller.jsp?model="+attrName);
				String fileNameCheckController=(String)((Map<String,Object>)model.get("controller")).get("checkAlias")+".java";
				createFile(dirController,fileNameCheckController,request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/checkcontroller.jsp?model="+attrName);
				String fileNameHtml=(String)((Map<String,Object>)model.get("html")).get("html");
				createFile(dirWeb,fileNameHtml,request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/html.jsp?model="+attrName);
				String fileNameJs=(String)((Map<String,Object>)model.get("html")).get("js");
				createFile(dirWeb,fileNameJs,request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/js.jsp?model="+attrName);
				
				File dirAndroidBean=new File(dirAndroid,(String)((Map<String,Object>)model.get("bean")).get("androidPackage"));
				dirAndroidBean.mkdir();
				String fileNameAndroidBean=(String)((Map<String,Object>)model.get("bean")).get("alias")+".java";
				createFile(dirAndroidBean,fileNameAndroidBean,request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/androidbean.jsp?model="+attrName);
				
				File dirAndroidMask=new File(dirAndroid,(String)((Map<String,Object>)model.get("bean")).get("androidMaskPackage"));
				dirAndroidMask.mkdir();
				String fileNameAndroidMask=(String)((Map<String,Object>)model.get("bean")).get("maskAlias")+".java";
				createFile(dirAndroidMask,fileNameAndroidMask,request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/androidmask.jsp?model="+attrName);
				
				File dirAndroidStub=new File(dirAndroid,(String)((Map<String,Object>)model.get("controller")).get("androidPackage"));
				dirAndroidStub.mkdir();
				String fileNameStub=(String)((Map<String,Object>)model.get("controller")).get("stub")+".java";
				createFile(dirAndroidStub,fileNameStub,request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/stub.jsp?model="+attrName);
				
			}
		}
		File zip=new File(dirName+".zip");
		createZip(dir,zip);
		zip.deleteOnExit();
		recvDelete(dir);
		response.setHeader("Content-Disposition","attachment; filename=download.zip");
		response.setContentLength((int)zip.length());
		sendFile(new FileInputStream(zip),response.getOutputStream());
	}
	private void sendFile(FileInputStream fileInputStream,ServletOutputStream outputStream) throws IOException
	{	byte[] buf=new byte[4096];
		int readLength;
		while(((readLength=fileInputStream.read(buf))!=-1))
		{	outputStream.write(buf,0,readLength);
		}
		fileInputStream.close();
		outputStream.flush();
		outputStream.close();
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{	doGet(request, response);
	}
	private static void createFile(File dir,String fileName,String urlStr) throws IOException
	{	URL url=new URL(urlStr);
		URLConnection conn=url.openConnection();
		InputStream inputStream=conn.getInputStream();
		byte[] data=readInputStream(inputStream);
		File file=new File(dir,fileName);
		FileOutputStream fileOutputStream=new FileOutputStream(file);
		fileOutputStream.write(data);
		if(fileOutputStream!=null)
			fileOutputStream.close();
		if(inputStream!=null)
			inputStream.close();
	}
	private static byte[] readInputStream(InputStream inputStream) throws IOException
	{	byte[] buffer=new byte[1024];
		int len=0;
		ByteArrayOutputStream bos=new ByteArrayOutputStream();
		while((len=inputStream.read(buffer))!=-1)
			bos.write(buffer,0,len);
		bos.close();
		return bos.toByteArray();
	}
	private static void createZip(File sourcePath,File zipPath) throws IOException
	{	FileOutputStream fos=new FileOutputStream(zipPath);
		ZipOutputStream zos=new ZipOutputStream(fos);
		recvWriteZip(sourcePath,"",zos);
		zos.close();
		fos.close();
	}
	private static void recvWriteZip(File file,String parentPath,ZipOutputStream zos) throws IOException
	{	if(file.exists())
		{	if(file.isDirectory())
			{	parentPath+=file.getName()+File.separator;
				File [] files=file.listFiles();
				for(File f:files)
					recvWriteZip(f,parentPath,zos);
			}
			else
			{	if(file.getName().contains("userrole.js"))
					System.out.println("xxxx");
				FileInputStream fis=null;
				DataInputStream dis=null;
				fis=new FileInputStream(file);
				dis=new DataInputStream(new BufferedInputStream(fis));
				ZipEntry ze=new ZipEntry(parentPath+file.getName());
				zos.putNextEntry(ze);
				byte[] content=new byte[1024];
				int len;
				while((len=fis.read(content))!=-1)
				{	zos.write(content,0,len);
					zos.flush();
				}
				if(dis!=null)
					dis.close();
			}
		}
	}
	private static boolean recvDelete(File dir)
	{	if(dir.isDirectory())
		{	String[] children=dir.list();
			for (int i=0;i<children.length;i++)
			{	boolean success=recvDelete(new File(dir,children[i]));
				if(!success)
					return false;
			}
		}
		return dir.delete();
	}
}