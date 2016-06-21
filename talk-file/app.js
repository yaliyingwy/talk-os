const express = require('express');
const logger = require('morgan');
const multipart = require('connect-multiparty');
const multipartMiddleware = multipart();
const bodyParser = require('body-parser');
const fs = require('fs');
const crypto = require('crypto');
const sizeOf = require('image-size');

const domain = require('domain');

const app = express();
app.use('/public', express.static('/data'));

app.use(logger('combined'));
app.use(bodyParser.json());

app.all('/upload', multipartMiddleware, (req, res, next) => {
	console.log(req.body, req.files);
	Object.keys(req.files).forEach((key) => {
		const file = req.files[key];
		const sha1 = crypto.createHash('sha1');
		sha1.update(file.path);
		const fileName = sha1.digest('hex');
		const downloadUrl = `${req.protocol}://talk-web.xegood.com:7002/public/${fileName}`;
		const result = {
			fileKey: fileName,
			downloadUrl,
			fileSize: file.size,
			fileType: file.type,
			mimeType: file.headers['content-type'],
			previewUrl: '',
			thumbnailUrl: downloadUrl,
			fileName: file.name,
			fileCategory: file.type.split('/')[0],
		};

		if (result.fileCategory === 'image') {
			sizeOf(file.path, (err, dimensions) => {
				result.imageWidth = dimensions.width;
				result.imageHeight = dimensions.height;
				res.json(result);
			});
		} else {
			res.json(result);
		}
		fs.createReadStream(file.path).pipe(fs.createWriteStream('/data/' + fileName));
	});
});

app.get('/download/:file', (req, res, next) => {
	const fileName = req.query.fileName || 'file';
	res.set({
		"Content-Disposition": 'attachment; filename="'+ encodeURIComponent(fileName)+'"',
	});
	const filePath = '/data/' + req.params.file;
	console.log('filePath:', filePath);
	fs.exists(filePath,(exists) => {
		if (exists) {
			res.sendFile(filePath);
		} else {
			res.status(404).send('文件不存在！');
		}
	});
});

app.use(function (req,res, next) {
  var d = domain.create();
  //监听domain的错误事件
  d.on('error', function (err) {
    console.error(err);
    res.json({code:'0001', msg: '服务器异常'});
    d.dispose();
  });
  
  d.add(req);
  d.add(res);
  d.run(next);
});

app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers


// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  console.error(err);
  res.json({
    message: err.message,
    error: {}
  });
});

app.listen(7002, () => console.log('file server listen on 7002'));