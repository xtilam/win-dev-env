Promise.prototype.safe = function() {
  return this.then((val) => ([val, undefined]), (err) => ([undefined, err || new Error('Unknown Error')]));
}

declare interface Promise<T> {
  safe(): Promise<[result: T, error: any]>;
}
