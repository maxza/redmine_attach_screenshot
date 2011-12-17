/*    */ package com.axmor.redmine.uploader;
/*    */ 
/*    */ import java.awt.Dimension;
/*    */ import java.awt.Graphics;
/*    */ import java.awt.image.BufferedImage;
/*    */ import javax.swing.JPanel;
/*    */ 
/*    */ public class ImagePanel extends JPanel
/*    */ {
/*    */   private static final long serialVersionUID = 5631821278779135825L;
/*    */   private BufferedImage image;
/*    */ 
/*    */   public ImagePanel()
/*    */   {
/* 37 */     super(true);
/*    */   }
/*    */ 
/*    */   public BufferedImage getImage()
/*    */   {
/* 44 */     return this.image;
/*    */   }
/*    */ 
/*    */   public void setImage(BufferedImage image)
/*    */   {
/* 51 */     this.image = image;
/* 52 */     if (image != null) {
/* 53 */       setPreferredSize(new Dimension(image.getWidth(), image.getHeight()));
/*    */     }
/* 55 */     updateUI();
/*    */   }
/*    */ 
/*    */   protected void paintComponent(Graphics g)
/*    */   {
/* 60 */     super.paintComponent(g);
/* 61 */     if (this.image != null)
/* 62 */       g.drawImage(this.image, 0, 0, this);
/*    */   }
/*    */ }

/* Location:           /home/tom/dev/redmine_attach_screenshot/assets/javascripts/uploader_applet.jar
 * Qualified Name:     com.axmor.redmine.uploader.ImagePanel
 * JD-Core Version:    0.6.0
 */